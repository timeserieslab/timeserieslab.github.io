module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Array as A
import Data.Maybe (fromMaybe)
import DOM (DOM)

import Data.TimeSeries as TS
import Data.TimeSeries.IO as IO


foreign import timestampToDate :: Number -> Number


main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  log "App started"


-- | Convert CSV to Time series
fromCsv :: String -> TS.Series Number
fromCsv str = fromMaybe TS.empty $ A.head (IO.fromCsv str)


toChartData :: TS.Series Number -> Array ({date :: Number, value :: Number})
toChartData xs = map f (TS.toDataPoints xs)
  where
    f dp = {date: timestampToDate dp.index, value: dp.value}