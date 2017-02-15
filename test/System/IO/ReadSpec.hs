module System.IO.ReadSpec where

import System.IO.Read (readFrom, readDirectory)

import System.FilePath ((</>), (<.>))

import Test.Hspec

data Foo = Foo
  { id :: Integer,
    name :: String,
    value :: Double,
    nested :: [(String, Bar)]
  }
  deriving (Read, Show, Eq)

data Bar = Bar
  { some :: Char
  }
  deriving (Read, Show, Eq)

dataPath :: FilePath
dataPath = "test" </> "data" 

pathFor :: String -> FilePath
pathFor s =
  dataPath </> s <.> "foo"

pathA :: FilePath
pathA = pathFor "a"

pathB :: FilePath
pathB = pathFor "b"

expectedA :: Foo
expectedA = Foo {
  id = 0,
  name = "a",
  value = 1.5,
  nested = [
    ("key 1", Bar { some = 'a'}),
    ("key 2", Bar { some = 'A'})
  ]
}

expectedB :: Foo
expectedB = Foo {
  id = 1,
  name = "b",
  value = 3.1234567800009,
  nested = [
  ("key 1", Bar { some = 'b'}),
  ("key 2", Bar { some = 'B'})
  ]
}

expected = [expectedA, expectedB]

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
