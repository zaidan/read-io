-----------------------------------------------------------------------------
-- |
-- Module      :  System.IO.Show
--
-- Show a to file
-----------------------------------------------------------------------------

module System.IO.Show
    ( showFile
    , writeFileUtf8
    ) where

import System.FilePath (FilePath)
import System.IO (openFile, hSetEncoding, hPutStr, hClose, utf8, IOMode(WriteMode))

-- -----------------------------------------------------------------------------
-- Writing

-- | Show a and write the result to given FilePath
showFile :: Show a => a -> FilePath -> IO ()
showFile a =
  writeFileUtf8 (show a)

-- | Write content to UTF-8 file
writeFileUtf8 :: String -> FilePath -> IO ()
writeFileUtf8 content path = do
  handle <- openFile path WriteMode
  hSetEncoding handle utf8
  hPutStr handle content
  hClose handle
