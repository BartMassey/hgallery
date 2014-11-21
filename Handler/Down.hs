-- Copyright © 2014 Bart Massey
-- Based on material Copyright © 2013 School of Haskell
-- https://www.fpcomplete.com/school/advanced-haskell/
--   building-a-file-hosting-service-in-yesod

-- This work is made available under the "GNU AGPL v3", as
-- specified the terms in the file COPYING in this
-- distribution.

{-# LANGUAGE OverloadedStrings #-}

module Handler.Down where

import Data.Text
import Data.Text.Encoding
import Text.Printf

import Yesod

import Foundation

getDownR :: Int -> Handler TypedContent
getDownR faid = do
  fa <- getById faid
  let mime = encodeUtf8 $ pack $ fileAssocMime fa
  let conts = toContent $ fileAssocContents fa
  addHeader "Content-Disposition" $ pack $
                  printf "attachment; filename=\"%s\"" $ fileAssocName fa
  sendResponse (mime, conts)
