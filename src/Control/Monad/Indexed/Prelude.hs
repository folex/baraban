{-|
Copyright Nicolas Trangez (c) 2016

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.

    * Neither the name of Nicolas Trangez nor the names of other
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Module      : Control.Monad.Indexed.Prelude
Description : A minimal @Prelude@ for indexed monads
Copyright   : (c) 2016, Nicolas Trangez
License     : BSD3

Combined with the @RebindableSyntax@ language extension, this module allows to
use standard @do@-notation in the context of /indexed/ monads.
-}

module Control.Monad.Indexed.Prelude (
    -- * Support for @RebindableSyntax@ (with 'fail' = 'error')
    (>>), (>>=), fail, ifThenElse,
    -- * 'Functor', 'Applicative' and 'Monad'-like operators
    (<$>), (<$), (<*>), (<*), (*>), pure, (=<<), return,
    -- * Re-exports
    -- ** Standard @Prelude@, without names defined in this module
    module Prelude,
    -- ** All of @Control.Monad.Indexed@
    module Control.Monad.Indexed,
    ) where

import Prelude hiding (
    (>>), (>>=), fail,
    (<$>), (<$), (<*>), (<*), (*>), pure, (=<<), return,
    )

import Control.Monad.Indexed

-- | Indexed version of 'Prelude.>>='.
(>>=) :: IxMonad m => m i j a -> (a -> m j k b) -> m i k b
(>>=) = (>>>=)
{-# INLINE (>>=) #-}

-- | Indexed version of 'Prelude.>>'.
(>>) :: IxMonad m => m i j a -> m j k b -> m i k b
a >> b = a >>= const b
{-# INLINE (>>) #-}

-- | `fail` is like 'Prelude.error'.
fail :: String -> m i j a
fail s = error $ "fail: " ++ s
{-# INLINE fail #-}

-- | Standard implementation for conditional constructs.
ifThenElse :: Bool -> a -> a -> a
ifThenElse b a1 a2 = if b then a1 else a2
{-# INLINE ifThenElse #-}

-- | Indexed version of 'Prelude.<$>'.
(<$>) :: IxFunctor f => (a -> b) -> f i j a -> f i j b
(<$>) = imap
{-# INLINE (<$>) #-}

-- | Indexed version of 'Prelude.<$'.
(<$) :: IxFunctor f => a -> f i j b -> f i j a
(<$) = imap . const
{-# INLINE (<$) #-}

-- | Indexed version of 'Prelude.<*>'.
(<*>) :: IxApplicative f => f i j (a -> b) -> f j k a -> f i k b
(<*>) = iap
{-# INLINE (<*>) #-}

-- | Indexed version of 'Prelude.<*'.
(<*) :: IxApplicative f => f i j a -> f j k b -> f i k a
a <* b = imap const a `iap` b
{-# INLINE (<*) #-}

-- | Indexed version of 'Prelude.*>'.
(*>) :: IxApplicative f => f i j a -> f j k b -> f i k b
a *> b = (const id `imap` a) `iap` b
{-# INLINE (*>) #-}

-- | Indexed version of 'Prelude.pure'.
pure :: IxPointed f => a -> f i i a
pure = ireturn
{-# INLINE pure #-}

-- | Indexed version of 'Prelude.=<<'.
(=<<) :: IxMonad m => (a -> m j k b) -> m i j a -> m i k b
(=<<) = flip (>>>=)
{-# INLINE (=<<) #-}

-- | Indexed version of 'Prelude.return'.
return :: IxPointed m => a -> m i i a
return = ireturn
{-# INLINE return #-}
