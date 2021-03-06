{-# LANGUAGE TypeOperators, DataKinds, RankNTypes, FlexibleContexts,
             TypeFamilies, ConstraintKinds, DeriveGeneric #-}

module Graphics.Rendering.Ombra.Shader.Stages (
        VertexShader,
        FragmentShader,
        VertexShaderOutput(Vertex),
        FragmentShaderOutput(..),
        VOShaderVars,
) where

import GHC.Generics
import Graphics.Rendering.Ombra.Shader.Language.Types
import Graphics.Rendering.Ombra.Shader.ShaderVar

-- | A 'Shader' with a 'VertexShaderOutput' output.
type VertexShader g i o = Shader g i (VertexShaderOutput ': o)

-- | 'ShaderVars' for the output of 'VartexShader'.
type VOShaderVars o = (ShaderVars o, ShaderVars (VertexShaderOutput ': o))

-- | A 'Shader' with only a 'FragmentShaderOutput' output.
type FragmentShader g i = Shader g i (FragmentShaderOutput ': '[])

-- | The position of the vertex.
data VertexShaderOutput = Vertex GVec4 deriving Generic

-- | The RGBA color of the fragment (1.0 = #FF), or the data of the draw
-- buffers.
data FragmentShaderOutput = Fragment0
                          | Fragment GVec4
                          | Fragment2 GVec4 GVec4
                          | Fragment3 GVec4 GVec4 GVec4
                          | Fragment4 GVec4 GVec4 GVec4 GVec4
                          | Fragment5 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment6 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment7 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment8 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment9 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                      GVec4
                          | Fragment10 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4
                          | Fragment11 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4
                          | Fragment12 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4 GVec4
                          | Fragment13 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment14 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment15 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                          | Fragment16 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4
                                       GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4 GVec4

instance {-# OVERLAPPING #-} ShaderVar FragmentShaderOutput where
        varPreName _ = "FragmentShaderOutput"
        varBuild _ _ = error "varBuild: can't build a FragmentShaderOutput"
        varToList _ Fragment0 = []
        varToList f (Fragment x0) = f 0 x0 : []
        varToList f (Fragment2 x0 x1) = f 0 x0 : f 1 x1 : []
        varToList f (Fragment3 x0 x1 x2) = f 0 x0 : f 1 x1 : f 2 x2 : []
        varToList f (Fragment4 x0 x1 x2 x3) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : []
        varToList f (Fragment5 x0 x1 x2 x3 x4) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 : []
        varToList f (Fragment6 x0 x1 x2 x3 x4 x5) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 : f 5 x5 : []
        varToList f (Fragment7 x0 x1 x2 x3 x4 x5 x6) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 :
                f 4 x4 : f 5 x5 : f 6 x6 : []
        varToList f (Fragment8 x0 x1 x2 x3 x4 x5 x6 x7) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 :
                f 4 x4 : f 5 x5 : f 6 x6 : f 7 x7 : []
        varToList f (Fragment9 x0 x1 x2 x3 x4 x5 x6 x7 x8) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 :
                f 4 x4 : f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : []
        varToList f (Fragment10 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 : []
        varToList f (Fragment11 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : []
        varToList f (Fragment12 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : f 11 x11 : []
        varToList f (Fragment13 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : f 11 x11 : f 12 x12 : []
        varToList f (Fragment14 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : f 11 x11 : f 12 x12 : f 13 x13 : []
        varToList f (Fragment15 x0 x1 x2 x3 x4 x5 x6 x7
                                x8 x9 x10 x11 x12 x13 x14) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : f 11 x11 : f 12 x12 : f 13 x13 :
                f 14 x14 : []
        varToList f (Fragment16 x0 x1 x2 x3 x4 x5 x6 x7 x8
                                x9 x10 x11 x12 x13 x14 x15) =
                f 0 x0 : f 1 x1 : f 2 x2 : f 3 x3 : f 4 x4 :
                f 5 x5 : f 6 x6 : f 7 x7 : f 8 x8 : f 9 x9 :
                f 10 x10 : f 11 x11 : f 12 x12 : f 13 x13 :
                f 14 x14 : f 15 x15 : []
