module System.IO.Foo where

import System.FilePath ((</>), (<.>))

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

pathC :: FilePath
pathC = pathFor "c"

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
