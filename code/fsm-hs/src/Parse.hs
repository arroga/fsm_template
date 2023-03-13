{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings #-}
module Parse (FsmDesc(..), templateName, templateName', Signal(..), State(..), Event(..),writeWtihEncoding) where

import Data.Yaml
import GHC.Generics (Generic)
import Data.Text.Lazy as TL
import Data.Text as T(unpack)
import Data.Text.IO
import Data.ByteString as B ( ByteString, writeFile )
import Data.Text.Encoding
import Data.Encoding 
import Debug.Trace
-- import Data.Encoding
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
    ,encoding :: String
    , signal :: [Signal]
    , state :: [State]
  }deriving (Show, Eq,Generic)
instance FromJSON FsmDesc
instance ToJSON FsmDesc



encode' :: (Show t, Encoding t) => String -> Maybe t -> ByteString
encode' _ Nothing =  error "error encoding"
encode' str (Just x) = trace (show x) encodeStrictByteString x str

writeWtihEncoding :: FilePath -> Text -> [Char] -> IO ()
writeWtihEncoding  path txt encoding = do 
  let txt0 = T.unpack $  TL.toStrict txt 
  let code = encodingFromStringExplicit encoding
  let txt1 = encode' txt0 code
  B.writeFile path txt1

