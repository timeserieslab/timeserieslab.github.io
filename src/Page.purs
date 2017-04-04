module Page (Query, page) where

import Prelude

import Data.Maybe (Maybe(..))

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP


data Query a = ToggleState a

type State = { on :: Boolean }

page :: forall m. H.Component HH.HTML Query Unit Void m
page =
  H.component
    { initialState: const initialState
    , render
    , eval
    , receiver: const Nothing
    }
  

initialState :: State
initialState = { on: false }

render :: State -> H.ComponentHTML Query
render state =
  renderNavibar
    

renderNavibar :: forall p i. HH.HTML p i
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


-- Query evaluation      
eval :: forall m. Query ~> H.ComponentDSL State Query Void m
eval = case _ of
  ToggleState next -> do
    H.modify (\state -> { on: not state.on })
    pure next
