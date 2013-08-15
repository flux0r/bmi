{-# LANGUAGE OverloadedStrings #-}

module Site where

import Data.ByteString (ByteString)
import Data.Text (Text)

import Snap (Initializer, Snaplet, SnapletInit,
    addRoutes, getOther, makeSnaplet, nestSnaplet, writeText
    )
import Snap.Snaplet.Config (AppConfig, appEnvironment)
import Snap.Snaplet.Heist (Heist, heistInit)
import Snap.Snaplet.PostgresqlSimple
import Snap.Http.Server (Config)

import Application

------------------------------------------------------------------------------
-- | Constants

bmiId :: Text
bmiId = "bmi"

bmiDesc :: Text
bmiDesc = "A personal website."

bmiFilePath :: Maybe (IO FilePath)
bmiFilePath = Nothing

tmplUrlRoot :: ByteString
tmplUrlRoot = ""

tmplDirectory :: FilePath
tmplDirectory = "templates"

dbUrlRoot :: ByteString
dbUrlRoot = "db"

mkConfigString :: Config m AppConfig -> Maybe String
mkConfigString = (appEnvironment =<<) . getOther

------------------------------------------------------------------------------
-- | Initialization

bmiSnaplet :: Initializer b v v -> SnapletInit b v
bmiSnaplet = makeSnaplet bmiId bmiDesc Nothing

tmplInitializer :: Initializer Bmi Bmi (Snaplet (Heist Bmi))
tmplInitializer = nestSnaplet tmplUrlRoot tmpl $ heistInit tmplDirectory

dbInitializer :: Initializer Bmi Bmi (Snaplet Postgres)
dbInitializer = nestSnaplet dbUrlRoot db pgsInit

bmi :: SnapletInit Bmi Bmi
bmi = bmiSnaplet $ do
    t <- tmplInitializer 
    d <- dbInitializer
    return $ Bmi t d
