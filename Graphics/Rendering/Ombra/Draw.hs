module Graphics.Rendering.Ombra.Draw (
        Draw,
        DrawState,
        Ctx,
        -- * Running the Draw monad
        refDrawCtx,
        runDrawCtx,
        execDrawCtx,
        evalDrawCtx,
        drawState,
        -- * Draw actions
        drawInit,
        clearBuffers,
        drawLayer,
        resizeViewport,
        -- ** Resources
        -- $resources
        preloadGeometry,
        preloadTexture,
        preloadProgram,
        removeGeometry,
        removeTexture,
        removeProgram,
        -- *
        gl
) where

import Data.IORef
import Graphics.Rendering.Ombra.Draw.Internal
import Graphics.Rendering.Ombra.Internal.GL hiding (Buffer)
import Graphics.Rendering.Ombra.Layer

-- | Run a Draw action using an IORef and a context.
refDrawCtx :: GLES => Ctx -> Draw a -> IORef DrawState -> IO a
refDrawCtx ctx d ref = do state <- readIORef ref
                          (ret, state') <- runDrawCtx ctx d state
                          writeIORef ref state'
                          return ret

runDrawCtx :: Ctx               -- ^ Context (use the appropriate backend
                                -- functions)
           -> Draw a            -- ^ Draw action
           -> DrawState         -- ^ State (create it with 'drawState')
           -> IO (a, DrawState)
runDrawCtx ctx d = flip evalGL ctx . runDraw d

execDrawCtx :: Ctx -> Draw a -> DrawState -> IO DrawState
execDrawCtx ctx d = flip evalGL ctx . execDraw d

evalDrawCtx :: Ctx -> Draw a -> DrawState -> IO a
evalDrawCtx ctx d = flip evalGL ctx . evalDraw d

-- renderSubLayer :: 

-- $resources
-- In Ombra, GPU resources are allocated when they're needed, and they're kept
-- alive by their corresponding CPU resources. Specifically, these resources are
-- Geometries, Textures and Programs. This means that, when a CPU resource is
-- garbage collected, the GPU resource is also removed. The functions below let
-- you manage allocation and deallocation manually.
