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
{-# LANGUAGE ViewPatterns #-}

module Dispatch where

import Data.Default ()
import Yesod
import Yesod.Default.Util ()

import Foundation
import Handler.Home
import Handler.Stats
import Handler.Raw
import Handler.Down

mkYesodDispatch "App" resourcesApp
