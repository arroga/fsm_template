
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
import Data.Text.Format ( Format, format, Only(Only) ) 

baseHTemp :: Format
baseHTemp = [r|
#ifndef _FSM_#EK9SA#_BASE_H_
#define _FSM_#EK9SA#_BASE_H_
#include "fsm_#ek9sa#_user.h"
{}
{}

extern fsm_sig_base_t fsm_#ek9sa#_sig[];
#endif
|]

userHTemp :: Format
userHTemp = [r|
#ifndef _FSM_#EK9SA#_USER_H_
#define _FSM_#EK9SA#_USER_H_
#include "fsm_base.h"
{}

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

baseCTemp :: Format
baseCTemp = [r|
#include "fsm_#ek9sa#_base.h"
{}
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
baseHName path x = path <> "/base/inc/" <> "fsm_" <> T.unpack (TL.toStrict x)  <> "_base.h"

baseCName :: String  -> Text->String
baseCName path x = path <> "/base/src/" <> "fsm_" <> T.unpack (TL.toStrict x)  <> "_base.c"

userHName :: String  -> Text->String
userHName path x = path <> "/user/inc/" <> "fsm_" <> T.unpack (TL.toStrict x)  <> "_user.h"

mkPortHFile :: String -> FsmDesc -> IO ()
mkPortHFile path fsm = do 
  writeWtihEncoding (portHName path fsm.name) txt1 fsm.encoding
    where 
      txt0 = TL.replace templateName (TL.toUpper fsm.name) portHTemp
      txt1 = TL.replace templateName' (fsm.name) txt0  

mkBaseHFile :: String -> FsmDesc -> IO ()
mkBaseHFile path fsm = do 
  writeWtihEncoding (baseHName path fsm.name)  txt2 fsm.encoding
    where 
      sigTxt = mkSigEnum fsm.name fsm.signal
      stateTxt = mkEnumState fsm
      txt0 = format baseHTemp (sigTxt,stateTxt)
      txt1 = TL.replace templateName (TL.toUpper fsm.name) txt0
      txt2 = TL.replace templateName' (fsm.name) txt1


mkUserHFile :: String -> FsmDesc -> IO ()
mkUserHFile path fsm = do 
  writeWtihEncoding (userHName path fsm.name)  txt2 fsm.encoding
    where 
      txt0 = format userHTemp (Only ("":: TL.Text))
      txt1 = TL.replace templateName (TL.toUpper fsm.name) txt0
      txt2 = TL.replace templateName' (fsm.name) txt1       

      
sigTempText :: Format
sigTempText = [r|
fsm_sig_base_t fsm_#ek9sa#_sig[] = 
{
{}
};|]

mkSigCText ::  Text -> [Signal] -> Text
mkSigCText name sigXs = format sigTempText ( Only txt )
  where 
    upName = TL.toUpper name
    temp sig = format [r|    {FSM_{}_{}_SIG}|] (upName , TL.toUpper sig.name )
    txt =  TL.intercalate ",\n" (temp <$> sigXs)

-- 生成fsm_xx_base.c文件，包含基本实现，由状态机关联生成的变量或者函数
mkbaseCFile :: String -> FsmDesc -> IO ()
mkbaseCFile path fsm = do 
  writeWtihEncoding (baseCName path fsm.name)  txt3 fsm.encoding
    where 
      sigTxt = mkSigCText fsm.name fsm.signal
      txt1 = format baseCTemp (Only sigTxt)
      txt2 = TL.replace templateName (TL.toUpper fsm.name) txt1
      txt3 = TL.replace templateName' (fsm.name) txt2 


fsmCFile :: Text
fsmCFile = [r|
#include "fsm_#ek9sa#_sig.h" 
#include "fsm_#ek9sa#_state.h" 
|]

-- baseCFile :: Text 
-- fsm


mkFsm :: FilePath -> FsmDesc -> IO ()
mkFsm path fsm = do
  ensureDir $ Path (path <> "/user/inc")
  ensureDir $ Path (path <> "/user/src")
  ensureDir $ Path (path <> "/base/inc")
  ensureDir $ Path (path <> "/base/src")
  mkStatFile path fsm 
  mkSigFile path fsm
  mkBaseHFile path fsm
  mkPortHFile path fsm  
  mkbaseCFile path fsm
  mkUserHFile path fsm