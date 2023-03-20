{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
module Signal (mkSigFile,mkSigEnum) where
import Parse 
import Text.RawString.QQ
import Data.List.Extra as LE
import GHC.Generics
import Data.Text.Lazy as TL
    ( intercalate,
      length,
      repeat,
      replace,
      take,
      toStrict,
      toUpper,
      Text )
import Data.Text.Format (format)
import Data.Text as T(unpack)
sigEnumTempHead :: Text
sigEnumTempHead= [r|
enum
{
    FSM_#EK9SA#_ENTRY_SIG = FSM_ENTRY_SIG,
    FSM_#EK9SA#_EXIT_SIG = FSM_EXIT_SIG,
|]

sigEnumTempLast :: Text
sigEnumTempLast= [r|
};|]

sigFuncDeclTempHead :: Text
sigFuncDeclTempHead = [r|

/**************#EK9SA#信号函数******************/
|]

sigFuncDeclTempLast:: Text
sigFuncDeclTempLast = [r|
/**************#EK9SA#信号函数******************/|]

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
    tFunc x = TL.toUpper $ format "    FSM_{}_{}_SIG," (name, x.name)
    -- 对齐
    mkSig x = txt <> TL.take (40 - TL.length txt ) (TL.repeat ' ') <> "/*" <> x.desc <> "*/"
      where txt = tFunc x
    -- 共用基信号
    sigText = mkSig <$> LE.filter (\ x -> x.name /= "entry" && x.name /= "exit") sigXs

--如果有继承的话就用继承函数
--如果没有继承的话就生成新的函数
mkSigFuncDecl0 :: Text->StateEvent->Text
mkSigFuncDecl0 name event = case event.parent of 
  "" ->format "fsm_hr_t fsm_{}_{}_{}_handler(fsm_{}_handler_t* const h,fsm_sig_base_t* const e);\n"  (name,event.state, event.sig, name)
  _ -> format "#define fsm_{}_{}_{}_handler fsm_{}_{}_{}_handler\n" (name,event.state, event.sig, name,event.parent,event.sig)

--生成信号描述，以及跟该信号关联的函数
mkSigFuncDecl' :: Text -> [State] -> Signal -> Text
mkSigFuncDecl' name stateXs sig = headText <> desc <>"\n" <>funcText <>endText
  where
    desc = "/*" <> sig.desc <> "*/"
    eventF :: State ->(Text,[Event])
    eventF state = (state.name, snd $ LE.break  (\x-> x.name == sig.name) state.event)
    r0 =  eventF <$> stateXs
    f0 (_, []) = ""
    f0 (x, y:_) = mkSigFuncDecl0 name  (StateEvent x sig.name  y.parent)
    r1 = f0 <$> r0
    -- eventS = 
    headText = TL.replace templateName (sig.name) sigFuncDeclTempHead
    endText = TL.replace templateName (sig.name) sigFuncDeclTempLast
    funcText = TL.intercalate ""  r1

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
  writeWtihEncoding (path <>"/base/inc/" <> fileName) text fsm.encoding
  where 
    hText = TL.replace templateName' fsm.name (TL.replace templateName (TL.toUpper fsm.name) hTempHText)
    sigFuncText = mkSigFuncDecl fsm
    text = hText <> sigFuncText <> hTempLText
    fileName = "fsm_" <> T.unpack  (TL.toStrict fsm.name) <>  "_sig.h"
-- func :: Signal -> String
-- func sig = sig.desc


mkSigFile :: FilePath -> FsmDesc -> IO ()
mkSigFile path fsm = do
  mkSigHFile path fsm