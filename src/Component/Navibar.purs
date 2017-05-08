module Component.Navibar (renderNavibar) where

import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP



renderNavibar :: ∀ p i. String -> HH.HTML p i
renderNavibar title = 
  HH.nav
    [ HP.class_ (H.ClassName "navbar navbar-default") ]
    [ HH.div 
      [ HP.class_ (H.ClassName "container-fluid") ]
      [ HH.div 
        [ HP.class_ (H.ClassName "navbar-header") ]
        [ HH.a  
          [ HP.class_ (H.ClassName "navbar-brand") 
          , HP.href "index.html"]
          [ HH.text "Time Series Lab" ]
        , HH.p 
          [ HP.class_ (H.ClassName "navbar-text") ]
          [ HH.text title ]
        ]
      , HH.button        
        [ HP.class_ (H.ClassName "btn btn-primary navbar-btn") 
        , HP.attr (HH.AttrName "data-toggle") "modal"
        , HP.attr (HH.AttrName "data-target") "#loadModal"
        ]
        [ HH.text "Load data" ]
      ]
    ]

-- <nav class="navbar navbar-default">
--     <div class="container-fluid">
--       <div class="navbar-header">
--         <a class="navbar-brand" href="index.html">Time Series Lab</a>
--         <p class="navbar-text">Plot Time Series.</p>
--       </div>
--         <button type="button" class="btn btn-primary navbar-btn" data-toggle="modal" data-target="#loadModal">
--           Load data
--         </button>
--     </div>
--   </nav>