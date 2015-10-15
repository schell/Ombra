{-# LANGUAGE GADTs, DataKinds, KindSignatures, TypeOperators, TypeFamilies,
             RankNTypes, FlexibleContexts, ScopedTypeVariables,
             MultiParamTypeClasses, FlexibleInstances, ConstraintKinds,
             UndecidableInstances #-}

module Graphics.Rendering.Ombra.Shader.ShaderVar (
        Shader(..),
        Valid,
        Member,
        Subset,
        Equal,
        Union,
        Insert,
        SVList(..),
        ShaderVar,
        BaseTypes,
        varPreName,
        varBuild,
        varToList,
        svFold,
        svToList,
        staticSVList
) where

import Data.Typeable (Proxy(..))
import GHC.Generics
import Graphics.Rendering.Ombra.Internal.TList
import Graphics.Rendering.Ombra.Shader.Language.Types (ShaderType)

infixr 4 :-

-- | An heterogeneous set of 'ShaderVar's.
data SVList :: [*] -> * where
        N :: SVList '[]
        (:-) :: (ShaderVar a, IsMember a xs ~ False)
             => a -> SVList xs -> SVList (a ': xs)

-- | The condition for a valid 'Shader'.

type Valid gs is os = (StaticSVList gs, StaticSVList is, StaticSVList os)

-- | A function from a (heterogeneous) set of uniforms and a set of inputs
-- (attributes or varyings) to a set of outputs (varyings).
type Shader gs is os = SVList gs -> SVList is -> SVList os

class GShaderVar (g :: * -> *) where
        type GBaseTypes g :: [*]

        gvarPreName :: g c -> String
        gvarBuild :: Int
                  -> (forall x. ShaderType x => Int -> x)
                  -> Proxy g
                  -> (g c, Int)
        gvarToList :: Int
                   -> (forall x. ShaderType x => Int -> x -> t)
                   -> g c
                   -> ([t], Int)
        
instance (GShaderVar a, GShaderVar b) => GShaderVar (a :*: b) where
        type GBaseTypes (a :*: b) = Append (GBaseTypes a) (GBaseTypes b)

        gvarPreName _ = error "gvarPreName: no info in :*:"

        gvarBuild i f (_ :: Proxy (a :*: b)) =
                let (x, i') = gvarBuild i f (Proxy :: Proxy a)
                    (y, i'') = gvarBuild i' f (Proxy :: Proxy b)
                in (x :*: y, i'')
                                             
        gvarToList i f (x :*: y) =
                let (l, i') = gvarToList i f x
                    (r, i'') = gvarToList i' f y
                in (l ++ r, i'')

instance (GShaderVar a, Datatype dt) => GShaderVar (M1 D dt a) where
        type GBaseTypes (M1 D dt a) = GBaseTypes a
        gvarPreName = datatypeName
        gvarBuild i f (_ :: Proxy (M1 D dt a)) =
                let (x, i') = gvarBuild i f (Proxy :: Proxy a)
                in (M1 x, i') 
        gvarToList i f (M1 x) = gvarToList i f x

instance GShaderVar a => GShaderVar (M1 S c a) where
        type GBaseTypes (M1 S c a) = GBaseTypes a
        gvarPreName _ = error "gvarPreName: no info in M1 S"
        gvarBuild i f (_ :: Proxy (M1 S c a)) =
                let (x, i') = gvarBuild i f (Proxy :: Proxy a)
                in (M1 x, i') 
        gvarToList i f (M1 x) = gvarToList i f x

instance GShaderVar a => GShaderVar (M1 C c a) where
        type GBaseTypes (M1 C c a) = GBaseTypes a
        gvarPreName _ = error "gvarPreName: no info in M1 C"
        gvarBuild i f (_ :: Proxy (M1 C c a)) =
                let (x, i') = gvarBuild i f (Proxy :: Proxy a)
                in (M1 x, i') 
        gvarToList i f (M1 x) = gvarToList i f x

instance ShaderType a => GShaderVar (K1 i a) where
        type GBaseTypes (K1 i a) = '[a]
        gvarPreName _ = error "gvarPreName: no info in K1"
        gvarBuild i f _ = (K1 $ f i, i + 1)
        gvarToList i f (K1 x) = ([f i x], i + 1)

type ShaderVar g = (GShaderVar (Rep g), Generic g)

type BaseTypes g = GBaseTypes (Rep g)

varPreName :: ShaderVar g => g -> String
varPreName = gvarPreName . from

varBuild :: ShaderVar g => (forall x. ShaderType x => Int -> x) -> Proxy g -> g
varBuild f (_ :: Proxy g) = to . fst $ gvarBuild 0 f (Proxy :: Proxy (Rep g))

varToList :: ShaderVar g
          => (forall x. ShaderType x => Int -> x -> t)
          -> g
          -> [t]
varToList f = fst . gvarToList 0 f . from

svFold :: (forall x. ShaderVar x => acc -> x -> acc) -> acc -> SVList xs -> acc
svFold _ acc N = acc
svFold f acc (x :- xs) = svFold f (f acc x) xs

svToList :: (forall x. ShaderVar x => x -> [y]) -> SVList xs -> [y]
svToList f = svFold (\acc x -> f x ++ acc) []

class StaticSVList (xs :: [*]) where
        -- | Create a 'SVList' with a function.
        staticSVList :: Proxy (xs :: [*])
                     -> (forall x. ShaderVar x => Proxy x -> x)
                     -> SVList xs

instance StaticSVList '[] where
        staticSVList (_ :: Proxy '[]) _ = N

instance (ShaderVar x, StaticSVList xs, IsMember x xs ~ False) =>
         StaticSVList (x ': xs) where
        staticSVList (_ :: Proxy (x ': xs)) f =
                f (Proxy :: Proxy x) :- staticSVList (Proxy :: Proxy xs) f
