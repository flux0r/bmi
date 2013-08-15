{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Main where

------------------------------------------------------------------------------
import Control.Applicative ((<|>))

------------------------------------------------------------------------------
import Snap (Snap, dir, ifTop, quickHttpServe)
import Snap.Util.FileServe (serveDirectory)
------------------------------------------------------------------------------

------------------------------------------------------------------------------
site :: Snap ()
site = ifTop (serveDirectory "./static") <|>
       dir "static" (serveDirectory "./static")

main :: IO ()
main = quickHttpServe site
