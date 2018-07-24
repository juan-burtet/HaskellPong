module Paths_pong_haskell (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/ittapupu/Faculdade/PF/pong-haskell/.cabal-sandbox/bin"
libdir     = "/home/ittapupu/Faculdade/PF/pong-haskell/.cabal-sandbox/lib/x86_64-linux-ghc-7.10.3/pong-haskell-0.1.0.0-5cRF5F0AN89AqnvT51JaA1"
datadir    = "/home/ittapupu/Faculdade/PF/pong-haskell/.cabal-sandbox/share/x86_64-linux-ghc-7.10.3/pong-haskell-0.1.0.0"
libexecdir = "/home/ittapupu/Faculdade/PF/pong-haskell/.cabal-sandbox/libexec"
sysconfdir = "/home/ittapupu/Faculdade/PF/pong-haskell/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "pong_haskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "pong_haskell_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "pong_haskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "pong_haskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "pong_haskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
