module Views ( showMetadata
             , plotSeries
             ) where

import Prelude
import Control.Monad.Eff (Eff)
import Data.Int (round)
import Data.Maybe (fromMaybe)
import DOM (DOM)

import Data.TimeSeries as TS

import Helpers (JSDate, mkDate, toISO)


type NodeId = String 


foreign import plotSeries :: ∀ e. Array ({date :: JSDate, value :: Number}) -> Eff (dom :: DOM | e) Unit
foreign import setNodeText :: ∀ e. NodeId -> String -> Eff (dom :: DOM | e) Unit


-- Show metadata about series
showMetadata :: ∀ a e. TS.Series a -> Eff (dom :: DOM | e) Unit
showMetadata xs = do
    let x1 = fromMaybe 0.0 $ TS.dpIndex <$> TS.head xs
    let x2 = fromMaybe 0.0 $ TS.dpIndex <$> TS.last xs
    let res = TS.resolution xs
    setNodeText "startDate" $ toISO (mkDate x1)
    setNodeText "endDate" $ toISO (mkDate x2)
    setNodeText "pointNumber" $ show (TS.length xs)
    setNodeText "timeRes" $ formatTimeDelta res


-- Convert time in millisecond into human readable format
formatTimeDelta :: Number -> String
formatTimeDelta dt = formatTimeDelta' $ round dt

-- Convert time in millisecond into human readable format
formatTimeDelta' :: Int -> String
formatTimeDelta' dt 
    | dt / 86400000 > 2 = show (dt / 86400000) <> " days."
    | dt / 3600000 > 2 = show (dt / 3600000) <> " hours."
    | dt / 60000 > 2 = show (dt / 60000) <> " minutes."
    | dt / 1000 > 2 = show (dt / 1000) <> " seconds."
    | otherwise = show dt <> " milliseconds."        
