module Chart (plotSeries) where

import Prelude
import Control.Monad.Eff (Eff)
import DOM (DOM)


foreign import plotSeries :: ∀ e. Array ({date :: Number, value :: Number}) -> Eff (dom :: DOM | e) Unit

