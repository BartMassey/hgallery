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

module Handler.Home where

import Control.Monad.Trans.Resource
import Data.Conduit
import Data.Conduit.Binary
import Data.Text (unpack)

import Data.Default
import Yesod
import Yesod.Default.Util

import Foundation

getHomeR :: Handler Html
getHomeR = do
  (formWidget, formEncType) <- generateFormPost uploadForm
  galleries <- getFAList
  defaultLayout $ do
    setTitle "HGallery"
    $(widgetFileNoReload def "home")

postHomeR :: Handler Html
postHomeR = do
  ((result, _), _) <- runFormPost uploadForm
  case result of
    FormSuccess fi -> do
      app <- getYesod
      fileBytes <- runResourceT $ fileSource fi $$ sinkLbs
      let fileAssoc = FileAssoc { fileAssocName = unpack $ fileName fi,
                                  fileAssocContents = fileBytes,
                                  fileAssocMime = unpack $ fileContentType fi,
                                  fileAssocId = 0 }
      addFile app fileAssoc
    _ -> return ()
  redirect HomeR

uploadForm = renderDivs $ fileAFormReq "file"
