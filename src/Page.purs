module Page where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Data.Maybe (Maybe(..))


data Query a = LoadSeries a
             | SeriesLoaded a

type State = { series :: Maybe String }

page :: forall m. H.Component HH.HTML Query Unit Void m
page =
  H.component
    { initialState: const initialState  -- query -> state const will creatre function which ignore query param
    , render                            --  state -> HTML
    , eval                              -- Query ->ComponentDSL state query output monad
    , receiver: const Nothing           -- 
    }
  

initialState :: State
initialState = { series: Nothing }

render :: State -> H.ComponentHTML Query
render state =
  HH.div_ 
    [ renderNavibar 
    , renderChart state
    , renderUploadSection
    ]
    

renderNavibar :: forall p. HH.HTML p (Query Unit)
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
renderChart :: forall p. State -> HH.HTML p (Query Unit)
renderChart state = 
  HH.div 
    [ HP.class_ (H.ClassName "panel panel-default") ]
    [ HH.div 
      [ HP.class_ (H.ClassName "panel-body") ]
      [ HH.text (show state.series) ]  
    ]


-- Render upload button
renderUploadSection :: forall p. HH.HTML p (Query Unit)
renderUploadSection = 
  HH.div 
    [ HP.class_ (H.ClassName "panel panel-default") ]
    [ HH.div 
      [ HP.class_ (H.ClassName "panel-body") ]
      [ HH.text "Select CSV file" 
      , HH.div_
        [ HH.input 
          [ HP.type_ HP.InputFile
          , HP.id_ "fileInput"
          , HE.onChange (HE.input_ LoadSeries)
          ] 
        ]
      ]
    ]
  


-- Query evaluation      
    -- var file = fileInput.files[0];
    -- var reader = new FileReader();
    -- reader.onload = function(e) {
    --     csvUploaded(reader.result);
    -- }
    -- reader.readAsText(file);
eval :: forall m. Query ~> H.ComponentDSL State Query Void m
eval = case _ of
  
  LoadSeries next -> do
    --  d <- document =<< window
    H.modify (\state -> { series: Just "loaded" })
    pure next

  SeriesLoaded next -> do
    pure next
