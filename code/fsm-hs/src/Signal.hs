{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}

module Signal (mkSigFuncDecl) where
import Parse 
import Text.RawString.QQ
import Data.List.Extra as LE
import GHC.Generics (Generic)
sigEnumTempHead :: String
sigEnumTempHead= [r|
enum
{
    EK9A_USER_SIG = FSM_USER_SIG,
|]

sigEnumTempLast :: String
sigEnumTempLast= [r|
}|]

sigFuncDeclTempHead :: String
sigFuncDeclTempHead = [r|

/**************#EK9SA#信号函数******************/
|]

sigFuncDeclTempLast:: String
sigFuncDeclTempLast = [r|
/**************#EK9SA#信号函数******************/|]


-- 生成信号枚举
mkSigEnum :: [Char] -> [String] -> String
mkSigEnum name sigXs = LE.replace templateName (LE.upper name)sigEnumTempHead <> LE.intercalate "\n" sigText <> sigEnumTempLast
  where 
    mkSig x = LE.upper ("    " <> name <>"_" <> x <> "_SIG," )
    sigText = mkSig <$> sigXs

-- 生成单信号所有状态函数声明
mkSigFuncDecl' :: String -> [State] -> Signal -> String
mkSigFuncDecl' name stateXs sig = headText <> desc <>"\n" <>funcText <>endText
  where 
    desc = "/*" <> sig.desc <> "*/"
    mkFuncDecl state = LE.lower(LE.concat ["fsm_hr_t fsm_",name, "_", state.name, "_", sig.name,"_handler(fsm_",name,"_handler_t* const h",", fsm_sig_base_t* const e);"] )
    stateYs = LE.filter  (\x -> sig.name `elem` x.signal ) stateXs
    headText = LE.replace templateName (sig.name) sigFuncDeclTempHead
    endText = LE.replace templateName (sig.name) sigFuncDeclTempLast
    funcText = LE.intercalate "\n"  (mkFuncDecl <$> stateYs)

-- 生成所有信号函数声明
mkSigFuncDecl :: FsmDesc -> String
mkSigFuncDecl fsm = 
  let txt = fmap (mkSigFuncDecl' fsm.name fsm.state) fsm.signal
    in LE.concat txt


-- 

-- func :: Signal -> String
-- func sig = sig.desc