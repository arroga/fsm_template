{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
module State (mkStatFile) where
import Text.RawString.QQ
import Data.List.Extra as LE
import Parse 
hNameTemp :: String -> String -> String
hNameTemp n s = "fsm_" <> n <> "_" <> s <> ".c"


cHeadTemp :: String
cHeadTemp  = [r|
#include "fsm_#ek9sa#_sig.h"
#include "fsm_#ek9sa#_state.h"
|]


cLastTemp :: String
cLastTemp = ""

-- 生成 fsm_ec_state_sig_handler
mkFunc :: String -> String -> String -> String
mkFunc n stateN sigN = LE.concat ["fsm_",n, "_", stateN, "_", sigN,"_handler"]

mkSigFunc' :: String->State->String
mkSigFunc' name state  = LE.concat (func <$> state.signal)
  where 
    func :: String -> String
    func sigName = LE.concat ["fsm_hr_t fsm_",name, "_", state.name, "_", sigName,
      "_handler(fsm_",name,"_handler_t* const h",", fsm_sig_base_t* const e)\n{\n        return FSM_SHANDLED;\n}\n\n"] 

--生成状态函数
mkStateText :: String -> State -> String
mkStateText name state = headT <> switchHT <> mkCaseT' <> switchLT <> "\n    return r;\n}"
  where 
    headT = LE.concat ["fsm_hr_t fsm_",name, "_", state.name,"_handler(fsm_",name,"_handler_t* const h",
      ", fsm_sig_base_t* const e)\n{\n","    fsm_hr_t r = FSM_SHANDLED;\n"]
    switchHT = "    switch(e->sig)\n    {\n" 
    switchLT = "    default:\n        break;\n    }"
    mkCaseT sig = "    case " <> LE.upper (LE.concat ["fsm_",name,"_",sig,"_SIG"]) <>":\n" <> "        r = " 
      <> mkFunc name state.name sig<>"(h,e);\n"
    mkCaseT' = LE.concat $ mkCaseT <$> state.signal

-- 生成C文本
mkCText' :: FilePath -> String -> State -> IO ()
mkCText' path name state = do 
  writeFile (path <> "/src/" <> hNameTemp name state.name) text
  where 
    cHeadText = LE.replace templateName' name cHeadTemp
    cLastText = LE.replace templateName' name cLastTemp
    funcText =  mkSigFunc' name state
    text = LE.concat [cHeadText, funcText, stateText,cLastText]
    stateText = mkStateText name state

mkCText :: FilePath -> FsmDesc->IO()
mkCText path s = do 
  mapM_ (mkCText' path s.name) s.state


hTempHText :: String
hTempHText = [r|
#ifndef APPLICATIONS_#EK9SA#_STATE_H_
#define APPLICATIONS_#EK9SA#_STATE_H_
#include "fsm_#ek9sa#_base.h"
|]

hTempLText :: String
hTempLText = [r|
#endif
|]

-- 新建fsm_xx_state.hs 里面包含状态函数声明
mkHText :: FilePath -> FsmDesc->IO()
mkHText path fsm = do 
  writeFile fileName text
  where 
    hText = LE.replace templateName' fsm.name (LE.replace templateName (LE.upper fsm.name) hTempHText)
    stateFunc state = LE.concat ["fsm_hr_t fsm_",fsm.name, "_", state.name,"_handler(fsm_",fsm.name,"_handler_t* const h",
      ", fsm_sig_base_t* const e);"]
    stateText = LE.intercalate "\n"  (stateFunc <$> fsm.state)
    text = hText <> stateText <> hTempLText
    fileName = path <> "/inc/" <> "fsm_" <> fsm.name <> "_state.h"

-- 新建状态函数文件
mkStatFile :: FilePath -> FsmDesc -> IO ()
mkStatFile path fsm = do
  mkCText path fsm
  mkHText path fsm