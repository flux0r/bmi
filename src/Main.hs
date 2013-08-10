{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Main where

------------------------------------------------------------------------------
import Control.Applicative ((<|>))
import Control.Lens (makeLenses)
import Data.ByteString (ByteString)
import Data.Text (Text)

------------------------------------------------------------------------------
import Snap (
    Config, Initializer, Snap, Snaplet, SnapletInit,
    dir, ifTop, makeSnaplet, nestSnaplet, quickHttpServe
    )
import Snap.Http.Server.Config (getOther)
import Snap.Snaplet.Config (AppConfig, appEnvironment)
import Snap.Snaplet.Heist (Heist, heistInit)
import Snap.Util.FileServe (serveDirectory)



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



------------------------------------------------------------------------------
site :: Snap ()
site = ifTop (serveDirectory "./static") <|>
       dir "static" (serveDirectory "./static")

main :: IO ()
main = quickHttpServe site

mkConfigString :: Config m AppConfig -> Maybe String
mkConfigString = (appEnvironment =<<) . getOther

data Bmi = Bmi {
    _tmpl :: Snaplet (Heist Bmi)
}

makeLenses ''Bmi



------------------------------------------------------------------------------
-- | Initialization

bmi :: SnapletInit Bmi Bmi
bmi = makeBmiSnaplet $ tmplInitializer >>= mkBmi

makeBmiSnaplet :: Initializer b v v -> SnapletInit b v
makeBmiSnaplet = makeSnaplet bmiId bmiDesc bmiFilePath

tmplInitializer :: Initializer Bmi Bmi (Snaplet (Heist Bmi))
tmplInitializer = nestSnaplet tmplUrlRoot tmpl $ heistInit tmplDirectory

mkBmi :: Monad m => Snaplet (Heist Bmi) -> m Bmi
mkBmi = return . Bmi
