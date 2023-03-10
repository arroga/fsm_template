{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
module State (mkStatFile) where
import Text.RawString.QQ
import Parse 
import Data.Text.Lazy as TL
    ( Text, concat, intercalate, replace, toStrict, toUpper )
import Data.Text.IO as TL
import Data.Text as T(unpack) 
import Data.Text.Format


-- h文件名字
hNameTemp :: Text -> Text -> String
hNameTemp n s = "fsm_"  <> T.unpack (TL.toStrict n) <> "_" <> T.unpack ( TL.toStrict s) <> ".c"

--C文件头模板
cHeadTemp :: Text
cHeadTemp  = [r|
#include "fsm_#ek9sa#_sig.h"
#include "fsm_#ek9sa#_state.h"
|]

--C文件末尾模板
cLastTemp :: Text
cLastTemp = ""

--事件函数模板
eventFuncInstTemp :: Format
eventFuncInstTemp = [r|
fsm_hr_t fsm_{}_{}_{}_handler(fsm_{}_handler_t* const h, fsm_sig_base_t* const e)
{
        return FSM_SHANDLED;
}
|]

-- 生成事件函数
mkEventFunc :: Text->State->Text
mkEventFunc name state  = TL.concat (func <$> fEvent)
  where 
    func event = format eventFuncInstTemp (name, state.name, event.name, name)
    --过滤事件，过滤掉继承类事件
    fEvent = filter (\x-> x.parent /= "") state.event

--状态函数实列模板
stateFuncInstTemp :: Format
stateFuncInstTemp = [r|
fsm_hr_t fsm_{}_{}_handler(fsm_{}_handler_t* const h, fsm_sig_base_t* const e)
{
    fsm_hr_t r = FSM_SHANDLED;
    switch(e->sig)
    {
{}
    default:
      break;
    }
    return r;
}
|]

--case文本模板
caseTemp :: Format
caseTemp = [r|
    case {}:
      r = fsm_{}_{}_{}_handler(h,e);
      break;
|]

--生成状态函数
mkStateText :: Text -> State -> Text
mkStateText name state = format stateFuncInstTemp (name, state.name,name,mkCaseT')
  where 
    mkCaseT event = format caseTemp (TL.toUpper (TL.concat ["fsm_",name,"_",event.name,"_SIG"]), name,name, state.name,event.name)
    mkCaseT' = TL.concat $ mkCaseT <$> state.event

-- 生成C文本
mkCText' :: FilePath -> Text -> State -> IO ()
mkCText' path name state = do 
  TL.writeFile (path <> "/src/" <> hNameTemp name state.name) (TL.toStrict txt)
  where 
    cHeadText = TL.replace templateName' name cHeadTemp
    cLastText = TL.replace templateName' name cLastTemp
    funcText =  mkEventFunc name state
    txt = TL.concat [cHeadText, funcText, stateText,cLastText]
    stateText = mkStateText name state

-- 生成所有C文件
mkCText :: FilePath -> FsmDesc->IO()
mkCText path s = do 
  mapM_ (mkCText' path s.name) s.state

-- h文件头模板
hTempHText :: Text
hTempHText = [r|
#ifndef APPLICATIONS_#EK9SA#_STATE_H_
#define APPLICATIONS_#EK9SA#_STATE_H_
#include "fsm_#ek9sa#_base.h"
|]

-- h文件尾模板
hTempLText :: Text 
hTempLText = [r|
#endif
|]

-- 新建fsm_xx_state.hs 里面包含状态函数声明
mkHText :: FilePath -> FsmDesc->IO()
mkHText path fsm = do 
  TL.writeFile fileName (TL.toStrict text)
  where 
    hText = TL.replace templateName' fsm.name (TL.replace templateName (TL.toUpper fsm.name) hTempHText)
    stateFunc state = TL.concat ["fsm_hr_t fsm_",fsm.name, "_", state.name,"_handler(fsm_",fsm.name,"_handler_t* const h",
      ", fsm_sig_base_t* const e);"]
    stateText = TL.intercalate "\n"  (stateFunc <$> fsm.state)
    text = hText <> stateText <> hTempLText
    fileName = path <> "/inc/" <> "fsm_" <> T.unpack (TL.toStrict fsm.name) <> "_state.h"

-- 新建状态函数文件
mkStatFile :: FilePath -> FsmDesc -> IO ()
mkStatFile path fsm = do
  mkCText path fsm
  mkHText path fsm