-- Copyright © 2014 Bart Massey
-- Based on material Copyright © 2013 School of Haskell
-- https://www.fpcomplete.com/school/advanced-haskell/
--   building-a-file-hosting-service-in-yesod

-- This work is made available under the "GNU AGPL v3", as
-- specified the terms in the file COPYING in this
-- distribution.

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ViewPatterns #-}
{-# LANGUAGE OverloadedStrings #-}

module Foundation where

import Control.Concurrent.STM
import Data.ByteString.Lazy (ByteString)
import Data.List (find)

import Data.Default
import Text.Hamlet
import Yesod
import Yesod.Default.Util

data FileAssoc = FileAssoc { fileAssocName :: String,
                             fileAssocContents :: ByteString }

data App = App (TVar [FileAssoc])

instance Yesod App where
  defaultLayout widget = do
    let wf = $(widgetFileNoReload def "default-layout")
    pageContent <- widgetToPageContent wf
    withUrlRenderer $(hamletFile "templates/default-layout-wrapper.hamlet")

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

mkYesodData "App" $(parseRoutesFile "config/routes")

getFilenamesList :: Handler [String]
getFilenamesList = do
  App state <- getYesod
  filesList <- liftIO $ readTVarIO state
  return $ map fileAssocName filesList

addFile :: App -> FileAssoc -> Handler ()
addFile (App state) op =
    liftIO $ atomically $
      modifyTVar state (op :)

getByFilename :: String -> Handler ByteString
getByFilename filename = do
  App state <- getYesod
  fileAssocs <- liftIO $ readTVarIO state
  case find ((== filename) . fileAssocName) fileAssocs of
    Just (FileAssoc { fileAssocContents = bytes }) -> return bytes
    _ -> notFound
