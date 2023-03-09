{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
module State () where
import Text.RawString.QQ
import Data.List.Extra as LE
import Parse 
hNameTemp :: String -> String -> String
hNameTemp n s = "fsm_" <> n <> "_" <> s <> ".c"


cHeadTemp :: String
cHeadTemp  = [r|
#include "fsm_#ek9sa#_signal.h"

|]


cLastTemp :: String
cLastTemp = ""


mkSigFunc' :: String->State->String
mkSigFunc' name state  = LE.concat (func <$> state.signal)
  where 
    func :: String -> String
    func sigName = LE.concat ["fsm_hr_t fsm_",name, "_", state.name, "_", sigName,
      "_handler(fsm_",name,"_handler_t* const h",", fsm_sig_base_t* const e)\n{\n    return FSM_SHANDLED;\n}\n\n"] 

-- 生成C文本
mkCText' :: FilePath -> String -> State -> IO ()
mkCText' path name state = do 
  writeFile (path <> "/" <> hNameTemp name state.name) text
  where 
    cHeadText = LE.replace templateName' name cHeadTemp
    cLastText = LE.replace templateName' name cLastTemp
    funcText =  mkSigFunc' name state
    text = LE.concat [cHeadText, funcText, cLastText]

mkCText :: FilePath -> FsmDesc->IO()
mkCText path s = do 
  mapM_ (mkCText' path s.name) s.state