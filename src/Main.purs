{-
 build command:
  ./build.sh
-}
module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.DOM (Node, addEventListener, querySelector, getBoundingClientRect, showClientRect)
import Control.Monad.Eff.Ref (REF, newRef, readRef, modifyRef)
import DOM (DOM)
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Partial.Unsafe (unsafePartial)
import Graphics.Canvas (CanvasElement, getCanvasDimensions, strokeText, fillText, setStrokeStyle, setFillStyle, setFont, CANVAS, getCanvasElementById, getContext2D)


main :: forall e. Eff ( console :: CONSOLE
                      , dom     :: DOM
                      , ref     :: REF
                      , canvas  :: CANVAS | e )
                      Unit
main = do
  log "Loaded"
  clickCount <- newRef 0
  mb_canvas  <- getCanvasElementById "canvas"
  case mb_canvas of
    Nothing     -> log "No canvas element"
    Just canvas -> do
      {width: width, height: height} <- getCanvasDimensions canvas
      let w = width /2.0 - 150.0
          h = height/2.0 + 15.0
      context <- getContext2D canvas
      setFont        "38pt Arial"     context
      setFillStyle   "cornflowerblue" context
      setStrokeStyle "blue"           context
      fillText   context "Hello Canvas" w h
      strokeText context "Hello Canvas" w h
      mb_canvas' <- querySelector "#canvas"
      case mb_canvas' of
        Nothing      -> pure unit
        Just canvas' -> do
          addEventListener canvas' "click" $ void do
            modifyRef clickCount \count -> count + 1
            count <- readRef clickCount
            log $ "Mouse clicked for the " <> show count <> "th time!"
            rect <- getBoundingClientRect canvas'
            for_ rect $ \r -> do
              xy <- windowToCanvas canvas' canvas {x:0.0,y:1.0}
              log (show xy.x <> ", " <> show xy.y)
              log (showClientRect r)
            pure unit
      pure unit

windowToCanvas :: forall e
                . Node
               -> CanvasElement
               -> { x :: Number, y :: Number }
               -> Eff ( dom :: DOM, canvas :: CANVAS | e )
                      {x :: Number, y :: Number }
windowToCanvas canvas canvas' xy = unsafePartial do
  Just bbox <- getBoundingClientRect canvas
  dim <- getCanvasDimensions canvas'
  let ret = { x: (xy.x - bbox.left) * (dim.width / bbox.width), y: (xy.y - bbox.top)  * (dim.height / bbox.height) }
  pure ret
