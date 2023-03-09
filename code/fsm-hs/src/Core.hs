{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
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
import Data.List.Extra as LE

mkFsm :: FilePath -> FsmDesc -> IO ()
mkFsm path fsm = do
  ensureDir $ Path (path <> "/" <> "inc")
  ensureDir $ Path (path <> "/" <> "src")
  mkStatFile path fsm 
  mkSigFile path fsm