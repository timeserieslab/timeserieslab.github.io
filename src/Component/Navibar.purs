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


-- renderLoadModal :: ∀ p i. String -> HH.HTML p i
-- renderLoadModal = 


  -- <div class="modal fade" id="loadModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  --   <div class="modal-dialog" role="document">
  --     <div class="modal-content">
  --       <div class="modal-header">
  --         <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  --         <h4 class="modal-title" id="myModalLabel">Load data</h4>
  --       </div>
  --       <div class="modal-body">
  --         <h2>Load from disk</h2>
  --         <div class="container">
  --           <div class="navbar-left navbar-text">Select CSV file</div>
  --           <div><input type="file" id="fileInput" class="btn"></div>    
  --         </div>

  --         <h2>Load from URL</h2>

  --         <div>
  --           <input type="text" size="50" id="urlText" placeholder="URL">
  --           <button onClick="loadUrl()" class="btn btn-default" data-dismiss="modal">Load</button>
  --         </div>

  --         <h2>Example Time Series</h2>

  --         <p>
  --           <button onClick="loadExample('small.csv');" class="btn btn-default" data-dismiss="modal">
  --             Small dataset
  --           </button>
  --           <button onClick="loadExample('turkey_elec.csv');" class="btn btn-default" data-dismiss="modal">
  --             Electricity demand
  --           </button>
  --           <button onClick="loadExample('test-24k.csv');" class="btn btn-default" data-dismiss="modal">
  --             Rainfall
  --           </button>
  --           <button onClick="loadExample('anomalies.csv');" class="btn btn-default" data-dismiss="modal">
  --             Anomalies 60K
  --           </button>
  --         </p>
  --         <div>
  --           Also check <a href="https://github.com/numenta/NAB/tree/master/data" target="_blank">Numenta NAB</a> 
  --           for some interesting datasets.
  --         </div>
  --       </div>
  --       <div class="modal-footer">
  --         <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
  --       </div>
  --     </div>
  --   </div>
  -- </div>
