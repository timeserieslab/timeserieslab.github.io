module Component.Navibar (renderNavibar) where

import Prelude
import Data.Const (Const)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP



renderNavibar :: ∀ a. String -> H.ComponentHTML (Const a)
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
            [ HP.class_ (H.ClassName "navbar-test") ]
            [ HH.text title ]
          ]
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