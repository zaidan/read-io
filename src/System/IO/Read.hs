-----------------------------------------------------------------------------
-- |
-- Module      :  System.IO.Read
--
-- Read a from FilePath
-----------------------------------------------------------------------------

module System.IO.Read
    ( readFrom
    , readIn
    , readDirectory
    , listAbsDirectory
    , listFromIndexedMap
    , indexedMap
    , indexed
    ) where

import System.Directory (canonicalizePath, listDirectory)
import System.FilePath ((</>))
import System.IO (openFile, IOMode(ReadMode), hSetEncoding, hGetContents, utf8)
import Data.List (sort)
import Data.Map (Map, fromList, toList)

-- -----------------------------------------------------------------------------
-- Reading

-- | Read UTF-8 file to String
readFileUtf8 :: FilePath -> IO String
readFileUtf8 path = do
  handle <- openFile path ReadMode
  hSetEncoding handle utf8
  hGetContents handle

-- | Read from given file path
readFrom :: (Read a) => FilePath -> IO a
readFrom path =
  readIO =<< readFileUtf8 =<< canonicalizePath path

-- | Read files in given basedir and subpath
readIn :: (Read a) => FilePath -> FilePath -> IO [a]
readIn basedir subpath =
  readDirectory (basedir </> subpath)

-- | Read from given directory
readDirectory :: (Read a) => FilePath -> IO [a]
readDirectory dir =
  mapM readFrom =<< listAbsDirectory dir

-- -----------------------------------------------------------------------------
-- Listing

-- | List directories with canonicalized paths
listAbsDirectory :: FilePath -> IO [FilePath]
listAbsDirectory dir =
  sort <$> listDirectory dir >>= mapM (canonicalizePath . (dir </>))

-- | Create list of files for given function and i^ndex.
listFromIndexedMap :: Read c => (b1 -> b2 -> IO FilePath) -> Map (a1, a2) (b1, b2) -> IO [((a1, a2), c)]
listFromIndexedMap f index  =
  sequence [ uncurry2 ((a1, b1), readIO =<< readFileUtf8 =<< f a2 b2) | ((a1, b1), (a2, b2)) <- toList index ]

-- | Uncurry
uncurry2 :: Functor f => (a1, f a) -> f (a1, a)
uncurry2 =
  uncurry $ fmap . (,)

-- -----------------------------------------------------------------------------
-- Indexing

-- | Create a indexed map from a and b
indexedMap :: (Ord t1, Ord t, Num t1, Num t, Enum t1, Enum t) => [t2] -> [t3] -> Map (t, t1) (t2, t3)
indexedMap a b =
  pairedMap (indexed a) (indexed b)

-- | Create an indexed list
indexed :: (Num a, Enum a) => [b] -> [(a, b)]
indexed =
  zip [0..]

-- | Create a paired map
pairedMap :: (Ord t1, Ord t) => [(t, t2)] -> [(t1, t3)] -> Map (t, t1) (t2, t3)
pairedMap a b =
  fromList $ pairedCartProd a b

-- | Create the paired cartesian product
pairedCartProd :: [(t, t2)] -> [(t1, t3)] -> [((t, t1), (t2, t3))]
pairedCartProd a b =
  [((a1, b1), (a2, b2)) | (a1, a2) <- a, (b1, b2) <- b]
