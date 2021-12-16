{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib where

import Control.Monad.IO.Class (liftIO)
import Data.Aeson (Value (..), object, (.=))
import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Encoding
import Data.ByteString.Char8 as BLU
import Data.IORef
import qualified Data.Map as Map
import qualified Data.Text.Conversions as TextConversions
import qualified Data.Text.Lazy as T
import Scripting.Duktape
import qualified Web.Scotty as S

-- {-# NOINLINE myAppState #-}
-- myAppState :: IORef (Map.Map String (Maybe String))
-- myAppState = unsafePerformIO (newIORef Map.empty)

-- readFromMyAppState :: String -> IO (Maybe String)
-- readFromMyAppState key = do
--   m <- readIORef myAppState
--   return (Map.findWithDefault Nothing key m)

-- writeToMyAppState :: String -> String -> IO ()
-- writeToMyAppState key val = do
--   m <- readIORef myAppState
--   writeIORef myAppState (Map.insert key (Just val) m)

myApp :: IORef (Map.Map String String) -> S.ScottyM ()
myApp store = do
  S.get "/" $ do
    S.text "hello"

  S.get "/some-json" $ do
    S.json $ object ["foo" .= Number 23, "bar" .= Number 42]

  S.get "/script/:name" $ do
    name <- S.param "name" :: S.ActionM String
    storeRef <- liftIO $ readIORef store
    let nameText = T.pack name
        script = Map.lookup name storeRef
    scriptResult <- liftIO $ evalDuktapeScript script
    S.text $ T.pack name

  S.post "/script/:name" $ do
    name <- S.param "name" :: S.ActionM String
    script <- S.param "script" :: S.ActionM String
    liftIO $
      modifyIORef store $ \s ->
        Map.insert name script s
    S.text (T.pack name)

stringToByteString :: String -> BLU.ByteString
stringToByteString = BLU.pack

evalDuktapeScript :: String -> IO (Maybe Aeson.Value)
evalDuktapeScript script = do
  dukm <- createDuktapeCtx
  case dukm of
    Nothing -> do
      Prelude.putStrLn "Failed to create Duktape context"
      return Nothing
    Just duk -> do
      output <- evalDuktape duk (BLU.pack script)
      case output of
        Left err -> do
          Prelude.putStrLn $ "Duktape error: " ++ show err
          return Nothing
        Right result -> do
          Prelude.putStrLn $ "Duktape says: " ++ show result
          return result

sampleDuktape :: IO ()
sampleDuktape = do
  dukm <- createDuktapeCtx
  case dukm of
    Nothing -> Prelude.putStrLn "Failed to create Duktape context"
    Just duk -> do
      output <- evalDuktape duk "(function() { return 'hello world'; })()"
      case output of
        Left err -> Prelude.putStrLn $ "Duktape error: " ++ show err
        Right result -> Prelude.putStrLn $ "Duktape says: " ++ show result
