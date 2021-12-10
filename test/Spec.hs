{-# LANGUAGE OverloadedStrings #-}

import Data.Aeson (Value (..), object, (.=))
import qualified Lib
import Test.Hspec
import Test.Hspec.Wai
  ( ResponseMatcher (matchHeaders, matchStatus),
    get,
    shouldRespondWith,
    with,
    (<:>),
  )
import qualified Web.Scotty as S

main :: IO ()
main = hspec spec

app = S.scottyApp Lib.myApp

spec = with app $ do
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
--     get "/some-json" `shouldRespondWith` [json|{foo: 23, bar: 42}|]