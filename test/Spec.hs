{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -Wno-deferred-out-of-scope-variables #-}

import Data.Aeson (Value (..), object, (.=))
import Data.IORef (IORef, newIORef, readIORef, writeIORef)
import Data.Map qualified as Map
import Lib qualified as Lib
import Network.Wai (Application)
import System.IO.Unsafe (unsafePerformIO)
import Test.Hspec
import Test.Hspec.Wai
  ( ResponseMatcher (matchHeaders, matchStatus),
    get,
    shouldRespondWith,
    with,
    (<:>),
  )
import Web.Scotty qualified as S

-- {-# NOINLINE myGlobalVar #-}
-- myGlobalVar :: IORef (Map.Map String (Maybe String))
-- myGlobalVar = unsafePerformIO (newIORef Map.empty)

-- readFromMyGlobalVar :: String -> IO (Maybe String)
-- readFromMyGlobalVar key = do
--   m <- readIORef myGlobalVar
--   return (Map.findWithDefault Nothing key m)

-- writeToMyGlobalVar :: String -> String -> IO ()
-- writeToMyGlobalVar key val = do
--   m <- readIORef myGlobalVar
--   writeIORef myGlobalVar (Map.insert key (Just val) m)

main :: IO ()
main = hspec spec

scottyMToApplication :: S.ScottyM () -> IO Application
scottyMToApplication = S.scottyApp

app :: IO Application
app = do
  emptyStringMap <- newIORef Map.empty
  scottyMToApplication (Lib.myApp emptyStringMap)

spec :: Spec
spec = do
  -- describe "Duktape.js Interpreter" $ do
  --   it "works" $ do
  --      Lib.evalDuktapeScript "(function() { return 'hello world'; })()" `shouldBe` (Just "hello world")

  with app $ do
    describe "GET /" $ do
      it "responds with 200" $ do
        get "/" `shouldRespondWith` 200

      it "responds with 'hello'" $ do
        get "/" `shouldRespondWith` "hello"

      it "responds with 200 / 'hello'" $ do
        get "/" `shouldRespondWith` "hello" {matchStatus = 200}

      it "has 'Content-Type: text/plain; charset=utf-8'" $ do
        get "/" `shouldRespondWith` 200 {matchHeaders = ["Content-Type" <:> "text/plain; charset=utf-8"]}

-- describe "GET /some-json" $ do
--   it "responds with some JSON" $ do
--     get "/some-json" `shouldRespondWith` [aesonQQ| { foo: 23, bar: 42 } |]