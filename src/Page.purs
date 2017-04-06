module Page where

import Prelude
import Control.Monad.Aff (Aff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))
import Network.HTTP.Affjax as AX


data Query a = LoadSeries a

type State = { loading :: Boolean
             , series :: Maybe String 
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
      , HH.div 
          [ HP.class_ (H.ClassName "container") ]
          [ HH.button
              [ HP.class_ (H.ClassName "btn btn-primary navbar-btn navbar-left")
              ,HE. onClick (HE.input_ LoadSeries)
              ]
              [ HH.text "Upload CSV" ]
          ]
      ]
    ]


-- Render Chart based on provided Time Series.
-- If there is no Series then render empty space
renderChart :: ∀ p. State -> HH.HTML p (Query Unit)
renderChart state = 
  HH.div 
    [ HP.class_ (H.ClassName "panel panel-default") ]
    [ HH.div 
      [ HP.class_ (H.ClassName "panel-body") ]
      [ HH.text (show state.series) ]  
    ]


-- Query evaluation      
eval :: ∀ eff. Query ~> H.ComponentDSL State Query Void (Aff (ajax :: AX.AJAX | eff))
eval = case _ of
  LoadSeries next -> do
    H.modify (_ { loading = true })
    response <- H.liftAff $ AX.get ("https://timeserieslab.github.io/testdata/small.csv")
    H.modify (_ { loading = false, series = Just response.response })
    pure next
