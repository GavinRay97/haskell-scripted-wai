{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Data.Aeson (Value (..), object, (.=))
import Scripting.Duktape
import qualified Web.Scotty as S

myApp = do
  S.get "/" $ do
    S.text "hello"

  S.get "/some-json" $ do
    S.json $ object ["foo" .= Number 23, "bar" .= Number 42]

sampleDuktape :: IO ()
sampleDuktape = do
  dukm <- createDuktapeCtx
  case dukm of
    Nothing -> putStrLn "Failed to create Duktape context"
    Just duk -> do
      output <- evalDuktape duk "console.log(42)"
      case output of
        Left err -> putStrLn $ "Duktape error: " ++ show err
        Right result -> putStrLn $ "Duktape says: " ++ show result
