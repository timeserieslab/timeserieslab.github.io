module AnomalyMain
  ( Event(..)
  , initState
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

import LinearAlgebra.Vector (sum)
import Data.TimeSeries as TS
import Data.TimeSeries.IO as IO

import Commons.Helpers (JSDate, mkDate)
import Commons.Views (plotSeries, showMetadata, showRange)


type State = 
  { series :: Maybe (TS.Series Number)  -- ^ Loaded Time series
  , startIndex :: Number                -- ^ Show series starting from this index
  , endIndex :: Number                  -- ^ Show up to this index
  }

data Event = SeriesLoaded String
           | ZoomIn
           | ZoomOut
           | NextFrame
           | PrevFrame
           | GroupBy Number


main :: ∀ e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  log "App started"


-- Initial state
initState :: State 
initState = { series: Nothing, startIndex: 0.0, endIndex: 0.0 }


-- | Update state for query SeriesLoaded
updateState :: State -> Event -> State
updateState st (SeriesLoaded csv) = {series: xs, startIndex: indexVal xs TS.head, endIndex: indexVal xs TS.last}
  where 
    xs = A.head (IO.fromCsv csv)

updateState state ZoomIn = state {endIndex = max endIndex minEndIndex}
  where 
    endIndex = state.startIndex + (state.endIndex - state.startIndex) / 2.0
    minEndIndex = state.startIndex + 5.0 * (fromMaybe 1000.0 (TS.resolution <$> state.series))

updateState state ZoomOut = state {endIndex = min endIndex maxEndIndex}
  where 
    endIndex = state.endIndex + (state.endIndex - state.startIndex)
    maxEndIndex = indexVal state.series TS.last

updateState state NextFrame = state {startIndex = state.startIndex + frame, endIndex = state.endIndex + frame}
  where
    frame1 = state.endIndex - state.startIndex
    frame2 = indexVal state.series TS.last - state.endIndex
    frame = min frame1 frame2

updateState state PrevFrame = state {startIndex = state.startIndex - frame, endIndex = state.endIndex - frame}
  where
    frame1 = state.endIndex - state.startIndex
    frame2 = state.startIndex - indexVal state.series TS.head
    frame = min frame1 frame2

updateState state (GroupBy dt) = state {series = TS.groupBy dt sum <$> state.series}


-- Helper function for getting index value
indexVal :: ∀ a. Maybe (TS.Series a) -> (TS.Series a -> Maybe (TS.DataPoint a)) -> Number
indexVal xs f = fromMaybe 0.0 $ TS.dpIndex <$> (xs >>= f)


-- | Render state
render :: ∀ e. State -> Eff (console :: CONSOLE, dom :: DOM | e) Unit
render {series: Nothing} = log "No series loaded"
render {series: Just xs, startIndex: si, endIndex: ei} = do 
  plotSeries (toChartData xs si ei)
  showRange si ei
  showMetadata xs
  -- showIndexHist xs


-- | Take n samples from given series
toChartData :: TS.Series Number 
            -> Number       -- ^ Start index
            -> Number       -- End index
            -> Array ({date :: JSDate, value :: Number})
toChartData xs si ei = map f $ TS.toDataPoints xs2
  where
    xs2 = TS.slice si ei xs
    f dp = {date: mkDate (TS.dpIndex dp), value: TS.dpValue dp}


