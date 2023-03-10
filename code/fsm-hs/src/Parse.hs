
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
module Parse (FsmDesc(..), templateName, templateName', Signal(..), State(..), Event(..)) where

import Data.Yaml
import GHC.Generics (Generic)
import Data.Text.Lazy as TL
-- import Data.Text
data Signal = Signal
  {
    name  :: Text ,
    desc :: Text
  } deriving (Show, Eq,Generic)

instance FromJSON Signal
instance ToJSON Signal

data Event = Event
  {
    name :: Text,
    parent :: Text
  } deriving (Show, Eq,Generic)

instance FromJSON Event
instance ToJSON Event

data State = State
  {
    name  :: Text ,
    desc :: Text,
    event :: [Event]
  } deriving (Show, Eq,Generic)

instance FromJSON State
instance ToJSON State

templateName :: Text
templateName = "#EK9SA#"

templateName' :: Text
templateName' = "#ek9sa#"


data FsmDesc = FsmDesc
  { name :: Text 
    , signal :: [Signal]
    , state :: [State]
  }deriving (Show, Eq,Generic)
instance FromJSON FsmDesc
instance ToJSON FsmDesc

