{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (Value (..), object, (.=))
import qualified Lib
import qualified Web.Scotty as S

main :: IO ()
main = do
  putStrLn "Starting server on port 3000"
  S.scotty 3000 Lib.myApp