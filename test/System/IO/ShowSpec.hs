module System.IO.ShowSpec where

import System.IO.Read (readFrom)
import System.IO.Show (showFile)

import System.IO.Foo

import System.Directory (removeFile)

import Test.Hspec

spec :: Spec
spec =
  describe "showFile" .
    it "should write a to c.foo and readFrom c.foo should be a " $ do
      showFile expectedA pathC
      foo <- System.IO.Read.readFrom pathC :: IO Foo
      foo `shouldBe` expectedA
      removeFile pathC
