module Main ( Event(..)
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

import Data.TimeSeries as TS
import Data.TimeSeries.IO as IO

import Helpers (JSDate, mkDate)
import Views (plotSeries, showMetadata, showRange)


type State = 
  { series :: Maybe (TS.Series Number)  -- ^ Loaded Time series
  , startIndex :: Number                -- ^ Show series starting from this index
  , endIndex :: Number                  -- ^ Show up to this index
  }

data Event = SeriesLoaded String


main :: ∀ e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  log "App started"


-- Initial state
initState :: State 
initState = { series: Nothing, startIndex: 0.0, endIndex: 0.0 }


-- | Update state for query SeriesLoaded
updateState :: State -> Event -> State
updateState st (SeriesLoaded csv) = {series: xs, startIndex: indexVal TS.head, endIndex: indexVal TS.last}
  where 
    xs = A.head (IO.fromCsv csv)
    indexVal f = fromMaybe 0.0 $ TS.dpIndex <$> (xs >>= f)


-- | Render state
render :: forall e. State -> Eff (console :: CONSOLE, dom :: DOM | e) Unit
render {series: Nothing} = log "No series loaded"
render {series: Just xs, startIndex: si, endIndex: ei} = do 
  plotSeries (toChartData 500 xs)
  showRange si ei
  showMetadata xs


-- | Take n samples from given series
toChartData :: Int -> TS.Series Number -> Array ({date :: JSDate, value :: Number})
toChartData n xs = map f $ A.take n (TS.toDataPoints xs)
  where
    f dp = {date: mkDate (TS.dpIndex dp), value: TS.dpValue dp}