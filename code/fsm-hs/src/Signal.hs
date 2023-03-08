{-# LANGUAGE QuasiQuotes #-}
module Signal () where
import Parse
import Text.RawString.QQ
import Data.List.Extra as LE
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
/**************EK9S信号函数******************/
|]

sigFuncDeclTempLast:: String
sigFuncDeclTempLast = [r|
/**************EK9S信号函数******************/
|]


-- 生成信号枚举
mkSigEnum :: [Char] -> [String] -> String
mkSigEnum name sigXs = LE.replace templateName (LE.upper name)sigEnumTempHead <> LE.intercalate "\n" sigText <> sigEnumTempLast
  where 
    mkSig x = LE.upper ("    " <> name <>"_" <> x <> "_SIG," )
    sigText = mkSig <$> sigXs


mkSigFuncDecl name stateXs sig = headText <> funcText <>endText
  where
    mkFuncDecl state = LE.lower(LE.concat ["fsm_",name, "_", state, "_", sig,"_handler"] )
    headText = LE.replace templateName (LE.upper name) sigFuncDeclTempHead
    endText = LE.replace templateName (LE.upper name) sigFuncDeclTempLast
    funcText = LE.intercalate "\n"  (mkFuncDecl <$> stateXs)