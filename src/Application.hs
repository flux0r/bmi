{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Application where

import Control.Lens (makeLenses)
import Snap (Handler, Snaplet, get, subSnaplet, with)
import Snap.Snaplet.Heist (HasHeist, Heist, heistLens)
import Snap.Snaplet.PostgresqlSimple (HasPostgres, Postgres, getPostgresState)

data Bmi = Bmi {
    _tmpl   :: Snaplet (Heist Bmi),
    _db     :: Snaplet Postgres
}

makeLenses ''Bmi

instance HasHeist Bmi where
    heistLens = subSnaplet tmpl

instance HasPostgres (Handler b Bmi) where
    getPostgresState = with db get

type BmiHandler = Handler Bmi Bmi
