-- Copyright © 2014 Bart Massey
-- Based on material Copyright © 2013 School of Haskell
-- https://www.fpcomplete.com/school/advanced-haskell/
--   building-a-file-hosting-service-in-yesod

-- This work is made available under the "GNU AGPL v3", as
-- specified the terms in the file COPYING in this
-- distribution.

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Foundation where

import Control.Concurrent.STM

import Yesod

data App = App (TVar [String])
instance Yesod App

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

mkYesodData "App" $(parseRoutesFile "config/routes")

getList :: Handler [String]
getList = do
  App state <- getYesod
  liftIO $ readTVarIO state

addFile :: App -> String -> Handler ()
addFile (App state) op =
    liftIO $ atomically $
      modifyTVar state (op :)
