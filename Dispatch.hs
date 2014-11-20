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

module Dispatch where

import Data.Default
import Yesod
import Yesod.Default.Util

import Foundation

mkYesodDispatch "App" resourcesApp

getHomeR :: Handler Html
getHomeR =
    defaultLayout $ do
      setTitle "Galleries"
      $(widgetFileNoReload def "home")
