module Component.Navibar (renderNavibar, renderLoadModal) where

import Prelude
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Properties.ARIA as HPA



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


renderLoadModal :: ∀ p i. HH.HTML p i
renderLoadModal = 
  HH.div 
    [ HP.class_ (H.ClassName "modal fade") 
    , HP.id_ "loadModal"
    , HP.tabIndex (-1)
    , HPA.role "dialog"
    , HPA.labelledBy "myModalLabel"
    ]
    [ HH.div 
      [ HP.class_ (H.ClassName "modal-dialog") 
      , HPA.role "document"
      ]
      [ HH.div 
        [ HP.class_ (H.ClassName "modal-content") ]
        [ HH.div 
          [ HP.class_ (H.ClassName "modal-header") ]
          [ HH.button 
            [ HP.class_ (H.ClassName "close") 
            , HP.attr (HH.AttrName "type") "button"
            , HP.attr (HH.AttrName "data-dismiss") "modal"
            , HPA.label "Close"
            ] 
            [ HH.span [HPA.hidden "true"] [HH.text "×"] ]
          , HH.h4 [ HP.class_ (H.ClassName "modal-title")] [HH.text "Load data"]
          ]
        , HH.div 
          [ HP.class_ (H.ClassName "modal-body") ]
          [ HH.h3_ [HH.text "Load from the disk"]
          , HH.div 
            [ HP.class_ (H.ClassName "container") ]
            [ HH.label 
              [ HP.class_ (H.ClassName "btn btn-primary btn-file") ]
              [ HH.text "Select CSV file"
              , HH.input 
                [ HP.attr (HH.AttrName "style") "display: none;"
                , HP.attr (HH.AttrName "type") "file"
                , HP.attr (HH.AttrName "data-dismiss") "modal"
                , HP.id_ "fileInput"
                ]
              ]
            ]

          , HH.h3_ [HH.text "Load from URL"]
          , HH.div 
            []
            [ HH.input 
              [ HP.attr (HH.AttrName "type") "text" 
              , HP.attr (HH.AttrName "size") "50" 
              , HP.id_ "urlText" 
              , HP.placeholder "URL"
              ]
            , HH.button 
              [ HP.class_ (H.ClassName "btn btn-default") 
              , HP.attr (HH.AttrName "data-dismiss") "modal"
              ] 
              [ HH.text "Load"] 
            ]

          , HH.h3_ [HH.text "Example Time Series"]
          , HH.p [] 
            [ HH.button 
              [ HP.class_ (H.ClassName "btn btn-default") 
              , HP.attr (HH.AttrName "data-dismiss") "modal"
              ] 
              [ HH.text "Small dataset"] 
            , HH.button 
              [ HP.class_ (H.ClassName "btn btn-default") 
              , HP.attr (HH.AttrName "data-dismiss") "modal"
              ] 
              [ HH.text "Electricity demand"] 
            , HH.button 
              [ HP.class_ (H.ClassName "btn btn-default") 
              , HP.attr (HH.AttrName "data-dismiss") "modal"
              ] 
              [ HH.text "Rainfall"] 
            , HH.button 
              [ HP.class_ (H.ClassName "btn btn-default") 
              , HP.attr (HH.AttrName "data-dismiss") "modal"
              ] 
              [ HH.text "Anomalies 60K"] 
            ]
          ]
        , HH.div 
          [ HP.class_ (H.ClassName "modal-footer") ]
          [ HH.button 
            [ HP.class_ (H.ClassName "btn btn-default") 
            , HP.attr (HH.AttrName "type") "button"
            , HP.attr (HH.AttrName "data-dismiss") "modal"
            ] 
            [ HH.text "Close"] 
          ]
        ]
      ]
    ]
