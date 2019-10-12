{- This file was auto-generated from raft/raft.proto by the proto-lens-protoc program. -}
{-# LANGUAGE ScopedTypeVariables, DataKinds, TypeFamilies,
  UndecidableInstances, GeneralizedNewtypeDeriving,
  MultiParamTypeClasses, FlexibleContexts, FlexibleInstances,
  PatternSynonyms, MagicHash, NoImplicitPrelude, DataKinds,
  BangPatterns, TypeApplications #-}
{-# OPTIONS_GHC -fno-warn-unused-imports#-}
{-# OPTIONS_GHC -fno-warn-duplicate-exports#-}
module Proto.Raft.Raft_Fields where
import qualified Data.ProtoLens.Runtime.Prelude as Prelude
import qualified Data.ProtoLens.Runtime.Data.Int as Data.Int
import qualified Data.ProtoLens.Runtime.Data.Monoid as Data.Monoid
import qualified Data.ProtoLens.Runtime.Data.Word as Data.Word
import qualified Data.ProtoLens.Runtime.Data.ProtoLens
       as Data.ProtoLens
import qualified
       Data.ProtoLens.Runtime.Data.ProtoLens.Encoding.Bytes
       as Data.ProtoLens.Encoding.Bytes
import qualified
       Data.ProtoLens.Runtime.Data.ProtoLens.Encoding.Growing
       as Data.ProtoLens.Encoding.Growing
import qualified
       Data.ProtoLens.Runtime.Data.ProtoLens.Encoding.Parser.Unsafe
       as Data.ProtoLens.Encoding.Parser.Unsafe
import qualified
       Data.ProtoLens.Runtime.Data.ProtoLens.Encoding.Wire
       as Data.ProtoLens.Encoding.Wire
import qualified Data.ProtoLens.Runtime.Data.ProtoLens.Field
       as Data.ProtoLens.Field
import qualified Data.ProtoLens.Runtime.Data.ProtoLens.Message.Enum
       as Data.ProtoLens.Message.Enum
import qualified
       Data.ProtoLens.Runtime.Data.ProtoLens.Service.Types
       as Data.ProtoLens.Service.Types
import qualified Data.ProtoLens.Runtime.Lens.Family2
       as Lens.Family2
import qualified Data.ProtoLens.Runtime.Lens.Family2.Unchecked
       as Lens.Family2.Unchecked
import qualified Data.ProtoLens.Runtime.Data.Text as Data.Text
import qualified Data.ProtoLens.Runtime.Data.Map as Data.Map
import qualified Data.ProtoLens.Runtime.Data.ByteString
       as Data.ByteString
import qualified Data.ProtoLens.Runtime.Data.ByteString.Char8
       as Data.ByteString.Char8
import qualified Data.ProtoLens.Runtime.Data.Text.Encoding
       as Data.Text.Encoding
import qualified Data.ProtoLens.Runtime.Data.Vector as Data.Vector
import qualified Data.ProtoLens.Runtime.Data.Vector.Generic
       as Data.Vector.Generic
import qualified Data.ProtoLens.Runtime.Data.Vector.Unboxed
       as Data.Vector.Unboxed
import qualified Data.ProtoLens.Runtime.Text.Read as Text.Read

heartbeat ::
          forall f s a .
            (Prelude.Functor f,
             Data.ProtoLens.Field.HasField s "heartbeat" a) =>
            Lens.Family2.LensLike' f s a
heartbeat = Data.ProtoLens.Field.field @"heartbeat"
id ::
   forall f s a .
     (Prelude.Functor f, Data.ProtoLens.Field.HasField s "id" a) =>
     Lens.Family2.LensLike' f s a
id = Data.ProtoLens.Field.field @"id"
leader ::
       forall f s a .
         (Prelude.Functor f, Data.ProtoLens.Field.HasField s "leader" a) =>
         Lens.Family2.LensLike' f s a
leader = Data.ProtoLens.Field.field @"leader"
maybe'heartbeat ::
                forall f s a .
                  (Prelude.Functor f,
                   Data.ProtoLens.Field.HasField s "maybe'heartbeat" a) =>
                  Lens.Family2.LensLike' f s a
maybe'heartbeat = Data.ProtoLens.Field.field @"maybe'heartbeat"
maybe'leader ::
             forall f s a .
               (Prelude.Functor f,
                Data.ProtoLens.Field.HasField s "maybe'leader" a) =>
               Lens.Family2.LensLike' f s a
maybe'leader = Data.ProtoLens.Field.field @"maybe'leader"
maybe'self ::
           forall f s a .
             (Prelude.Functor f,
              Data.ProtoLens.Field.HasField s "maybe'self" a) =>
             Lens.Family2.LensLike' f s a
maybe'self = Data.ProtoLens.Field.field @"maybe'self"
maybe'stand ::
            forall f s a .
              (Prelude.Functor f,
               Data.ProtoLens.Field.HasField s "maybe'stand" a) =>
              Lens.Family2.LensLike' f s a
maybe'stand = Data.ProtoLens.Field.field @"maybe'stand"
maybe'value ::
            forall f s a .
              (Prelude.Functor f,
               Data.ProtoLens.Field.HasField s "maybe'value" a) =>
              Lens.Family2.LensLike' f s a
maybe'value = Data.ProtoLens.Field.field @"maybe'value"
maybe'vote ::
           forall f s a .
             (Prelude.Functor f,
              Data.ProtoLens.Field.HasField s "maybe'vote" a) =>
             Lens.Family2.LensLike' f s a
maybe'vote = Data.ProtoLens.Field.field @"maybe'vote"
self ::
     forall f s a .
       (Prelude.Functor f, Data.ProtoLens.Field.HasField s "self" a) =>
       Lens.Family2.LensLike' f s a
self = Data.ProtoLens.Field.field @"self"
stand ::
      forall f s a .
        (Prelude.Functor f, Data.ProtoLens.Field.HasField s "stand" a) =>
        Lens.Family2.LensLike' f s a
stand = Data.ProtoLens.Field.field @"stand"
term ::
     forall f s a .
       (Prelude.Functor f, Data.ProtoLens.Field.HasField s "term" a) =>
       Lens.Family2.LensLike' f s a
term = Data.ProtoLens.Field.field @"term"
vote ::
     forall f s a .
       (Prelude.Functor f, Data.ProtoLens.Field.HasField s "vote" a) =>
       Lens.Family2.LensLike' f s a
vote = Data.ProtoLens.Field.field @"vote"