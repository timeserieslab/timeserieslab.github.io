module Helpers ( JSDate
               , mkDate 
               , toISO 
               ) where


data JSDate = JSDate 


foreign import mkDate :: Number -> JSDate

foreign import toISO :: JSDate -> String

