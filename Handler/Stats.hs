-- Copyright © 2014 Bart Massey
-- Based on material Copyright © 2013 School of Haskell
-- https://www.fpcomplete.com/school/advanced-haskell/
--   building-a-file-hosting-service-in-yesod

-- This work is made available under the "GNU AGPL v3", as
-- specified the terms in the file COPYING in this
-- distribution.

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}

module Handler.Stats where

import Control.Exception hiding (Handler)
import qualified Data.ByteString.Lazy as LB
import Data.Default
import qualified Data.Text.Lazy as LT
import qualified Data.Text.Lazy.Encoding as LT
import Text.Blaze

import Yesod
import Yesod.Default.Util

import Foundation

getStatsR :: String -> Handler Html
getStatsR filename = do
  bytes <- getByFilename filename
  defaultLayout $ do
    setTitle . toMarkup $ "File Processor - " ++ filename
    statsBlock <- liftIO $ stats bytes
    $(widgetFileNoReload def "stats")

stats :: LB.ByteString -> IO Widget
stats bytes = do
  eText <- try $ evaluate $
             LT.decodeUtf8 bytes :: IO (Either SomeException LT.Text)
  case eText of
    Left _ -> return [whamlet|<pre>Unable to display file contents.|]
    Right text -> return [whamlet|<pre>#{text}|]
