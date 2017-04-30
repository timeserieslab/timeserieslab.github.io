module Main ( initState
            , main
            , render
            , updateState
            ) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Array as A
import Data.Maybe (Maybe(..), fromMaybe)
import DOM (DOM)

import Data.TimeSeries as TS
import Data.TimeSeries.IO as IO

import Chart (plotSeries)

foreign import timestampToDate :: Number -> Number

type State = 
  { series :: Maybe (TS.Series Number)
  }


main :: ∀ e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  log "App started"


-- Initial state
initState :: State 
initState = { series: Nothing }


-- | Update state for query SeriesLoaded
updateState :: State -> String -> State
updateState st csv = {series: Just xs}
  where 
    xs = fromMaybe TS.empty $ A.head (IO.fromCsv csv)


-- | Render state
render :: forall e. State -> Eff (console :: CONSOLE, dom :: DOM | e) Unit
render {series: Nothing} = log "No series loaded"
render {series: Just xs} = plotSeries (toChartData 500 xs)


-- | Take n samples from given series
toChartData :: Int -> TS.Series Number -> Array ({date :: Number, value :: Number})
toChartData n xs = map f $ A.take n (TS.toDataPoints xs)
  where
    f dp = {date: timestampToDate dp.index, value: dp.value}