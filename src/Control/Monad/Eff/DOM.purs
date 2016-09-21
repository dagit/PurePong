module Control.Monad.Eff.DOM where

import Prelude
import Control.Monad.Eff (Eff)
import DOM (DOM)
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe(..))

-- TODO: this would be simpler if I used the types from purescript-canvas
-- instead of declaring types here

foreign import data Node :: *

foreign import querySelectorImpl
  :: forall eff r
   . Fn3 r
         (Node -> r)
         String
         (Eff (dom :: DOM | eff) r)

querySelector
  :: forall eff
   . String
  -> Eff (dom :: DOM | eff) (Maybe Node)
querySelector s = runFn3 querySelectorImpl Nothing Just s

foreign import addEventListener
  :: forall eff
   . Node
  -> String
  -> Eff (dom :: DOM | eff) Unit
  -> Eff (dom :: DOM | eff) Unit

-- foreign import data ClientRect :: *

type ClientRect = { top    :: Number
                  , left   :: Number
                  , width  :: Number
                  , height :: Number
                  }

showClientRect :: ClientRect -> String
showClientRect cr = "{ top = " <> show cr.top  <>
                    ", left = " <> show cr.left <>
                    ", width = " <> show cr.width <>
                    ", height = " <> show cr.height <> "}"

foreign import getBoundingClientRectImpl
  :: forall eff r
   . Fn3 r
         (ClientRect -> r)
         Node
         (Eff (dom :: DOM | eff) r)

getBoundingClientRect
  :: forall eff
   . Node
  -> Eff (dom :: DOM | eff) (Maybe ClientRect)
getBoundingClientRect n = runFn3 getBoundingClientRectImpl Nothing Just n
