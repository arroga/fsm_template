
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE DuplicateRecordFields #-}
module Parse (FsmDesc(..), templateName, Signal(..), State(..)) where

import Data.Yaml
import GHC.Generics (Generic)

data Signal = Signal
  {
    name  :: String ,
    desc :: String
  } deriving (Show, Eq,Generic)

instance FromJSON Signal
instance ToJSON Signal

data State = State
  {
    name  :: String ,
    desc :: String,
    signal :: [String]
  } deriving (Show, Eq,Generic)

instance FromJSON State
instance ToJSON State

templateName :: String
templateName = "EK9S"

data FsmDesc = FsmDesc
  { name :: String 
    , signal :: [Signal]
    , state :: [State]
  }deriving (Show, Eq,Generic)
instance FromJSON FsmDesc
instance ToJSON FsmDesc


func :: Signal -> String
func sig = sig.desc