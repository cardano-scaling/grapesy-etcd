{-# LANGUAGE TemplateHaskell #-}

module Etcd.Embed where

import Control.Monad.Catch (MonadMask)
import Control.Monad.IO.Class (MonadIO)
import Data.ByteString qualified as BS
import Data.WhichEmbed (embedWhich, withEmbeddedExe)
import Path (Abs, File, Path)

etcd :: BS.ByteString
etcd = $(embedWhich "etcd")

withEmbeddedEtcd ::
    (MonadIO m) =>
    (MonadMask m) =>
    (Path Abs File -> m a) ->
    m a
withEmbeddedEtcd = withEmbeddedExe "etcd" etcd
