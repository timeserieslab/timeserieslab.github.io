module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Aff (Aff)
import Data.Array as A
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Network.HTTP.Affjax as AX

import Data.TimeSeries as TS
import Data.TimeSeries.IO (fromCsv)


data Query a = LoadSeries a

type State = { loading :: Boolean
             , series :: Maybe (TS.Series Number)
             }


page :: ∀ eff. H.Component HH.HTML Query Unit Void (Aff (ajax :: AX.AJAX | eff))
page =
  H.component
    { initialState: const initialState  -- query -> state const will creatre function which ignore query param
    , render                            -- state -> HTML
    , eval                              -- Query ->ComponentDSL state query output monad
    , receiver: const Nothing           -- 
    }
  

initialState :: State
initialState = { loading: false, series: Nothing }


render :: State -> H.ComponentHTML Query
render state =
  HH.div_ 
    [ renderNavibar 
    , renderChart state
    , renderExamples
    , renderFooter
    ]
    

renderNavibar :: ∀ p. HH.HTML p (Query Unit)
renderNavibar = 
  HH.nav
    [ HP.class_ (H.ClassName "navbar navbar-default") ]
    [ HH.div 
      [ HP.class_ (H.ClassName "container-fluid") ]
      [ HH.div 
          [ HP.class_ (H.ClassName "navbar-header") ]
          [ HH.a  
            [ HP.class_ (H.ClassName "navbar-brand") 
            , HP.href "#"]
            [ HH.text "Time Series Lab" ]
          ]
      ]
    ]


-- Render Chart based on provided Time Series.
-- If there is no Series then render empty space
renderChart :: ∀ p. State -> HH.HTML p (Query Unit)
renderChart state = 
  HH.div 
    [ HP.class_ (H.ClassName "container") ]
    [ HH.text (show state.series) ]  


-- Render list of example datasets
renderExamples :: ∀ p. HH.HTML p (Query Unit)
renderExamples = 
  HH.div 
    [ HP.class_ (H.ClassName "container") ]
    [ HH.h2_ [ HH.text "Example Time Series" ]
    , HH.div_
      [ HH.button
        [ HP.class_ (H.ClassName "btn btn-primary")
        , HE. onClick (HE.input_ LoadSeries)
        ]
        [ HH.text "Small dataset" ]
      , HH.text " "
      , HH.button
        [ HP.class_ (H.ClassName "btn btn-primary")
        , HE. onClick (HE.input_ LoadSeries)
        ]
        [ HH.text "Anomalies 60K" ]
      , HH.text " "
      , HH.button
        [ HP.class_ (H.ClassName "btn btn-primary")
        , HE. onClick (HE.input_ LoadSeries)
        ]
        [ HH.text "Turkey daily electricity demand" ]
      ]
    ]  


-- Render footer
renderFooter :: ∀ p. HH.HTML p (Query Unit)
renderFooter = 
  HH.footer 
    [ HP.class_ (H.ClassName "container") ]
    [ HH.hr_
    , HH.a  
      [ HP.href "https://github.com/timeserieslab/timeserieslab.github.io"]
      [ HH.text "Github.com" ]
    ]



-- Query evaluation      
eval :: ∀ eff. Query ~> H.ComponentDSL State Query Void (Aff (ajax :: AX.AJAX | eff))
eval = case _ of
  LoadSeries next -> do
    H.modify (_ { loading = true })
    response <- H.liftAff $ AX.get ("https://timeserieslab.github.io/testdata/small.csv")
    H.modify (_ { loading = false, series = A.head (fromCsv response.response) })
    pure next


main :: Eff (HA.HalogenEffects (ajax :: AX.AJAX)) Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI page unit body
