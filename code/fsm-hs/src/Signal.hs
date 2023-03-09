{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
module Signal (mkSigFile) where
import Parse 
import Text.RawString.QQ
import Data.List.Extra as LE
sigEnumTempHead :: String
sigEnumTempHead= [r|
enum
{
    FSM_#EK9SA#_ENTRY_SIG = FSM_ENTRY_SIG,
    FSM_#EK9SA#_EXIT_SIG = FSM_EXIT_SIG,
    FSM_#EK9SA#_USER_SIG = FSM_USER_SIG,
|]

sigEnumTempLast :: String
sigEnumTempLast= [r|
};|]

sigFuncDeclTempHead :: String
sigFuncDeclTempHead = [r|

/**************#EK9SA#信号函数******************/
|]

sigFuncDeclTempLast:: String
sigFuncDeclTempLast = [r|/**************#EK9SA#信号函数******************/|]


-- 生成信号枚举

mkSigEnum :: String -> [Signal] -> [Char]
mkSigEnum name sigXs = LE.replace templateName (LE.upper name) sigEnumTempHead <> LE.intercalate "\n" sigText <> sigEnumTempLast
  where 
    tFunc x = LE.upper $ LE.concat ["    " ,"FSM_" , name ,"_" , x.name , "_SIG,"]
    mkSig x = txt <> LE.take (40 - LE.length txt ) (LE.repeat ' ') <> "/*" <> x.desc <> "*/"
      where txt = tFunc x
    sigText = mkSig <$> LE.filter (\ x -> x.name /= "entry" && x.name /= "exit") sigXs

-- 生成单信号所有状态函数声明
mkSigFuncDecl' :: String -> [State] -> Signal -> String
mkSigFuncDecl' name stateXs sig = headText <> desc <>"\n" <>funcText <>endText
  where 
    desc = "/*" <> sig.desc <> "*/"
    mkFuncDecl state = LE.lower (LE.concat ["fsm_hr_t fsm_",name, "_", state.name, "_", sig.name,"_handler(fsm_",name,"_handler_t* const h,",   
      "fsm_sig_base_t* const e);\n"] )
    stateYs = LE.filter  (\x -> sig.name `elem` x.signal ) stateXs
    headText = LE.replace templateName (sig.name) sigFuncDeclTempHead
    endText = LE.replace templateName (sig.name) sigFuncDeclTempLast
    funcText = LE.intercalate "\n"  (mkFuncDecl <$> stateYs)

-- 生成所有信号函数声明
mkSigFuncDecl :: FsmDesc -> String
mkSigFuncDecl fsm = 
  let txt = fmap (mkSigFuncDecl' fsm.name fsm.state) fsm.signal
    in LE.intercalate "\n" txt

hTempHText :: String
hTempHText = [r|
#ifndef APPLICATIONS_#EK9SA#_SIG_H_
#define APPLICATIONS_#EK9SA#_SIG_H_
#include "fsm_#ek9sa#_base.h"
|]

hTempLText :: String
hTempLText = [r|
#endif
|]

-- 创建信号h文本
mkSigHFile :: FilePath -> FsmDesc->IO()
mkSigHFile path fsm = do 
  writeFile (path <> "/" <>"/inc/" <> fileName) text
  where 
    hText = LE.replace templateName' fsm.name (LE.replace templateName (LE.upper fsm.name) hTempHText)
    sigEnumText = mkSigEnum fsm.name (fsm.signal)
    sigFuncText = mkSigFuncDecl fsm
    text = hText <> sigEnumText <> sigFuncText <> hTempLText
    fileName = "fsm_" <> fsm.name <>  "_sig.h"
-- func :: Signal -> String
-- func sig = sig.desc


mkSigFile :: FilePath -> FsmDesc -> IO ()
mkSigFile path fsm = do
  mkSigHFile path fsm