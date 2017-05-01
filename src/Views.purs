module Views ( showMetadata
             , plotSeries
             ) where

import Prelude
import Control.Monad.Eff (Eff)
import DOM (DOM)

import Data.TimeSeries as TS

import Helpers (JSDate, mkDate)


type NodeId = String 


foreign import plotSeries :: ∀ e. Array ({date :: JSDate, value :: Number}) -> Eff (dom :: DOM | e) Unit
foreign import setNodeText :: ∀ e. NodeId -> String -> Eff (dom :: DOM | e) Unit


-- Show metadata about series
showMetadata :: ∀ a e. TS.Series a -> Eff (dom :: DOM | e) Unit
showMetadata xs = do
    setNodeText "startDate" "Start date"
    setNodeText "endDate" "End date"
    setNodeText "pointNumber" $ show (TS.length xs)
    setNodeText "timeRes" "Time distance between points"


