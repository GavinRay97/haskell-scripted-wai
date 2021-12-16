{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (Value (..), object, (.=))
import Data.IORef (newIORef)
import Data.Map qualified as Map
import Lib qualified
import Web.Scotty qualified as S

main :: IO ()
main = do
  putStrLn "Starting server on port 3000"
  emptyStringMap <- newIORef Map.empty
  S.scotty 3000 (Lib.myApp emptyStringMap)