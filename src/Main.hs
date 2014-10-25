{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Applicative
import           Snap.Core
import           Snap.Util.FileServe
import           Snap.Http.Server
import           Control.Monad.IO.Class

main :: IO ()
main = do
    httpServe (setPort 8003 config) site
        where
         config =
             setErrorLog  ConfigNoLog $
             setAccessLog ConfigNoLog $
             defaultConfig

site :: Snap ()
site =
    ifTop xxx <|>
    route [ ("foo", writeBS "bar")
          , ("echo/:echoparam", echoHandler)
          , ("/lol/", serveDirectory "../io")
          , ("nav", serveDirectory "../nav_slide")
          , ("sign", serveDirectory "../sign")
          --, ("/js", serveDirectory "../semantic.gs")
          ] <|>
    dir "static" (serveDirectory ".")

echoHandler :: Snap ()
echoHandler = do
    param <- getParam "echoparam"
    maybe (writeBS "must specify echo/param in URL")
          writeBS param

xxx :: Snap ()
xxx = do
   req <- getRequest
   let a = getHeader "user-agent" req
   told <- maybe pass return a
   writeBS told
--   modifyResponse $ addHeader "Content-Type" "application/json; charset=UTF-8"
--   modifyResponse $ addHeader "Server" "One"
--   writeBS "{\"message\":\"hello world\",\"message1\":\"What's up world?\"}"
