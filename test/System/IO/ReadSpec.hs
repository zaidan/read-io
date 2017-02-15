module System.IO.ReadSpec where

import System.IO.Read (readFrom, readDirectory)

import System.IO.Foo

import Test.Hspec

ia :: IO Foo
ia = readFrom pathA

ib :: IO Foo
ib = readFrom pathB

idir :: IO [Foo]
idir = readDirectory dataPath

spec :: Spec
spec = do
  describe "readFrom" $ do
    it "should read a" $ do
      a <- ia
      a `shouldBe` expectedA
    it "should read b" $ do
      b <- ib
      b `shouldBe` expectedB

  describe "readDirectory" $ do
    it "should read a and b from direcory" $ do
      dir <- idir
      dir `shouldBe` expected
