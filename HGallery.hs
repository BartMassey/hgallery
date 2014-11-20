-- Copyright © 2014 Bart Massey
-- Based on material Copyright © 2013 School of Haskell
-- https://www.fpcomplete.com/school/advanced-haskell/
--   building-a-file-hosting-service-in-yesod

-- This work is made available under the "GNU AGPL v3", as
-- specified the terms in the file COPYING in this
-- distribution.

-- Photo Gallery in Yesod, with persistence, versioning and
-- archivable metadata. Work in progress.

{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}

module Main where

import Data.Default
import Yesod
import Yesod.Default.Util

data App = App
instance Yesod App

mkYesod "App" $(parseRoutesFile "config/routes")

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "HGallery"
    $(widgetFileNoReload def "home")

main :: IO ()
main = warpEnv App
