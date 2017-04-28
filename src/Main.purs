module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

import DOM (DOM)
import DOM.HTML (window)
import DOM.HTML.Window (document)
import DOM.HTML.Types (htmlDocumentToNonElementParentNode)
import DOM.Node.NonElementParentNode (getElementById)
import DOM.Node.Types (ElementId(..))


main :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
main = do
  connectButtons


-- | Connect buttons loading example datasets
connectButtons :: forall e. Eff (console :: CONSOLE, dom :: DOM | e) Unit
connectButtons = do
  doc <- document <$> window
  -- btnData1 <- getElementById (ElementId "btnData1") (htmlDocumentToNonElementParentNode doc)
  log $ "ok" --show btnData1
  