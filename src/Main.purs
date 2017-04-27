module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import DOM.HTML (window)
import DOM.HTML.Window (document)


main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  connectButtons


-- | Connect buttons loading example datasets
connectButtons :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
connectButtons = do
  doc <- document <$> window
  log doc
  -- getElementById "" doc
