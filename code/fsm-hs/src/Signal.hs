{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
module Signal (mkSigFile) where
import Parse 
import Text.RawString.QQ
import Data.List.Extra as LE
import GHC.Generics
import Data.Text.Lazy as TL
import Data.Text.IO as TL
import Data.Text.Format (format)
import Data.Text as T(unpack)
sigEnumTempHead :: Text
sigEnumTempHead= [r|
enum
{
    FSM_#EK9SA#_ENTRY_SIG = FSM_ENTRY_SIG,
    FSM_#EK9SA#_EXIT_SIG = FSM_EXIT_SIG,
    FSM_#EK9SA#_USER_SIG = FSM_USER_SIG,
|]

sigEnumTempLast :: Text
sigEnumTempLast= [r|
};|]

sigFuncDeclTempHead :: Text
sigFuncDeclTempHead = [r|

/**************#EK9SA#信号函数******************/
|]

sigFuncDeclTempLast:: Text
sigFuncDeclTempLast = [r|/**************#EK9SA#信号函数******************/|]

data StateEvent = StateEvent
  {
    state :: Text,
    sig :: Text,
    parent :: Text
  } deriving(Show, Eq,Generic)

-- 生成信号枚举
mkSigEnum :: Text -> [Signal] -> Text
mkSigEnum name sigXs = TL.replace templateName (TL.toUpper name) sigEnumTempHead <> TL.intercalate "\n" sigText <> sigEnumTempLast
  where 
    tFunc x = TL.toUpper $ format "    FSM_{}_{}_SIG" (name, x.name)
    -- 对齐
    mkSig x = txt <> TL.take (40 - TL.length txt ) (TL.repeat ' ') <> "/*" <> x.desc <> "*/"
      where txt = tFunc x
    -- 共用基信号
    sigText = mkSig <$> LE.filter (\ x -> x.name /= "entry" && x.name /= "exit") sigXs


mkSigFuncDecl0 :: Text->StateEvent->Text
mkSigFuncDecl0 name event = case event.parent of 
  "" -> format "#define fsm_{}_{}_{}_handler fsm_{}_{}_{}_handler" (name,event.state, event.sig, name,event.state, event.parent)
  _ -> format "fsm_hr_t fsm_{}_{}_{}_handler(fsm_{}_handler_t* const h,fsm_sig_base_t* const e);"  (name,event.state, event.sig, name)




mkSigFuncDecl' :: Text -> [State] -> Signal -> Text
mkSigFuncDecl' name stateXs sig = headText <> desc <>"\n" <>funcText <>endText
  where
    desc = "/*" <> sig.desc <> "*/"
    eventF :: State ->(Text,[Event])
    eventF state = (state.name, snd $ LE.break  (\x-> x.name == sig.name) state.event)
    r0 =  eventF <$> stateXs
    f0 (_, []) = ""
    f0 (x, y:_) = mkSigFuncDecl0 name  (StateEvent x sig.name  y.name)
    r1 = f0 <$> r0
    -- eventS = 
    headText = TL.replace templateName (sig.name) sigFuncDeclTempHead
    endText = TL.replace templateName (sig.name) sigFuncDeclTempLast
    funcText = TL.intercalate "\n"  r1


-- -- 生成单信号所有状态函数声明
-- mkSigFuncDecl' :: String -> [State] -> Signal -> String
-- mkSigFuncDecl' name stateXs sig = headText <> desc <>"\n" <>funcText <>endText
--   where 
--     desc = "/*" <> sig.desc <> "*/"
--     mkFuncDecl state = TL.lower (TL.concat ["fsm_hr_t fsm_",name, "_", state.name, "_", sig.name,"_handler(fsm_",name,"_handler_t* const h,",   
--       "fsm_sig_base_t* const e);\n"] )
--     --过滤掉状态中没有该信号的
--     stateYs = TL.filter  (\x -> sig.name `elem` ((\y->y.name) <$> x.event) ) stateXs
--     headText = TL.replace templateName (sig.name) sigFuncDeclTempHead
--     endText = TL.replace templateName (sig.name) sigFuncDeclTempLast
--     funcText = TL.intercalate "\n"  (mkFuncDecl <$> stateYs)

-- 生成所有信号函数声明
mkSigFuncDecl :: FsmDesc -> Text
mkSigFuncDecl fsm = 
  let txt = fmap (mkSigFuncDecl' fsm.name fsm.state) fsm.signal
    in TL.intercalate "\n" txt

hTempHText :: Text
hTempHText = [r|
#ifndef APPLICATIONS_#EK9SA#_SIG_H_
#define APPLICATIONS_#EK9SA#_SIG_H_
#include "fsm_#ek9sa#_base.h"
|]

hTempLText :: Text
hTempLText = [r|
#endif
|]

-- 创建信号h文本
mkSigHFile :: FilePath -> FsmDesc->IO()
mkSigHFile path fsm = do 
  TL.writeFile (path <> "/" <>"/inc/" <> fileName) (TL.toStrict text)
  where 
    hText = TL.replace templateName' fsm.name (TL.replace templateName (TL.toUpper fsm.name) hTempHText)
    sigEnumText = mkSigEnum fsm.name (fsm.signal)
    sigFuncText = mkSigFuncDecl fsm
    text = hText <> sigEnumText <> sigFuncText <> hTempLText
    fileName = "fsm_" <> T.unpack  (TL.toStrict fsm.name) <>  "_sig.h"
-- func :: Signal -> String
-- func sig = sig.desc


mkSigFile :: FilePath -> FsmDesc -> IO ()
mkSigFile path fsm = do
  mkSigHFile path fsm