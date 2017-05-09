module Commons.Views 
    ( showMetadata
    , plotSeries
    , showAnomalies
    , showIndexHist
    , showRange
    ) where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.Array as A
import Data.Int (round)
import Data.Maybe (Maybe(..), fromMaybe)
import DOM (DOM)

import Data.TimeSeries as TS
import Statistics.Sample as S

import Commons.Helpers (JSDate, mkDate, toISO)


type NodeId = String 


foreign import plotSeries :: ∀ e. Array ({date :: JSDate, value :: Number}) -> Eff (dom :: DOM | e) Unit
foreign import setNodeText :: ∀ e. NodeId -> String -> Eff (dom :: DOM | e) Unit


-- Show metadata about series
showMetadata :: ∀ a e. TS.Series a -> Eff (dom :: DOM | e) Unit
showMetadata xs = do
    let x1 = fromMaybe 0.0 $ TS.dpIndex <$> TS.head xs
    let x2 = fromMaybe 0.0 $ TS.dpIndex <$> TS.last xs
    let res = TS.resolution xs
    let missing = (round ((x2-x1) / res)) - (TS.length xs) + 1
    setNodeText "startDate" $ toISO (mkDate x1)
    setNodeText "endDate" $ toISO (mkDate x2)
    setNodeText "pointNumber" $ show (TS.length xs)
    setNodeText "timeRes" $ formatTimeDelta res
    setNodeText "missingPoints" $ show missing


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


showRange :: ∀ e. Number -> Number -> Eff (dom :: DOM | e) Unit
showRange x1 x2 = do
    setNodeText "showStart" $ toISO (mkDate x1)
    setNodeText "showEnd" $ toISO (mkDate x2)


-- Show histogram of index values    
showIndexHist :: ∀ a e. TS.Series a -> Eff (console :: CONSOLE, dom :: DOM | e) Unit
showIndexHist xs = do
    let idx1 = TS.index xs
    let idx2 = A.zipWith (\x1 x2 -> x2-x1) idx1 (fromMaybe [] (A.tail idx1))
    log $ "Index histogram " <> show (S.histogram idx2)


-- Show anomaly count
showAnomalies :: ∀ e. Maybe Int -> Eff (console :: CONSOLE, dom :: DOM | e) Unit
showAnomalies Nothing = setNodeText "anomalies" ""
showAnomalies (Just n) = setNodeText "anomalies" $ show n
