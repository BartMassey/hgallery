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

import Data.Text (unpack)

import Data.Default
import Yesod
import Yesod.Default.Util

import Foundation

getHomeR :: Handler Html
getHomeR = do
  (formWidget, formEncType) <- generateFormPost uploadForm
  galleries <- getList
  defaultLayout $ do
    setTitle "HGallery"
    $(widgetFileNoReload def "home")

postHomeR :: Handler Html
postHomeR = do
  ((result, _), _) <- runFormPost uploadForm
  case result of
    FormSuccess fi -> do
      app <- getYesod
      addFile app $ unpack $ fileName fi
    _ -> return ()
  redirect HomeR

uploadForm = renderDivs $ fileAFormReq "file"
