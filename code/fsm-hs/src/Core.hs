
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}

module Core
    ( 
      module Parse,
      module Signal,
      module State
    ) where
import Parse
import Signal
import State
import Path.IO
import Path.Internal
import Text.RawString.QQ
import Data.Text.Lazy as TL
import Data.Text as T(unpack)

baseHTemp :: Text
baseHTemp = [r|
#ifndef _FSM_#EK9SA#_BASE_H_
#define _FSM_#EK9SA#_BASE_H_
#include "fsm_base.h"

typedef struct
{

} fsm_#ek9sa#_init_t;

typedef struct
{
    fsm_handler_base_t parent;
    fsm_#ek9sa#_init_t init;
} fsm_#ek9sa#_handler_t;
#endif
|]

portHTemp :: Text
portHTemp = [r|
#ifndef _FSM_#EK9SA#_H_
#define _FSM_#EK9SA#_H_
#include "fsm_#ek9sa#_state.h"
#include "fsm_#ek9sa#_sig.h"
#endif 
|]


portHName :: String  -> Text->String
portHName path x = path <> "/" <> "fsm_" <> T.unpack (TL.toStrict x)  <> ".h"

baseHName :: String  -> Text->String
baseHName path x = path <> "/inc/" <> "fsm_" <> T.unpack (TL.toStrict x)  <> "_base.h"


mkPortHFile :: String -> FsmDesc -> IO ()
mkPortHFile path fsm = do 
  writeWtihEncoding (portHName path fsm.name) txt1 fsm.encoding
    where 
      txt0 = TL.replace templateName (TL.toUpper fsm.name) portHTemp
      txt1 = TL.replace templateName' (fsm.name) txt0  

mkbaseHFile :: String -> FsmDesc -> IO ()
mkbaseHFile path fsm = do 
  writeWtihEncoding (baseHName path fsm.name)  txt1 fsm.encoding
    where 
      txt0 = TL.replace templateName (TL.toUpper fsm.name) baseHTemp
      txt1 = TL.replace templateName' (fsm.name) txt0  


fsmCFile :: Text
fsmCFile = [r|
#include "fsm_#ek9sa#_sig.h" 
#include "fsm_#ek9sa#_state.h" 
|]

mkFsm :: FilePath -> FsmDesc -> IO ()
mkFsm path fsm = do
  ensureDir $ Path (path <> "/" <> "inc")
  ensureDir $ Path (path <> "/" <> "src")
  mkStatFile path fsm 
  mkSigFile path fsm
  writeFile (portHName path fsm.name) ""
  mkbaseHFile path fsm
  mkPortHFile path fsm