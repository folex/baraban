{- This file was auto-generated from raft/raft.proto by the proto-lens-protoc program. -}
{-# LANGUAGE ScopedTypeVariables, DataKinds, TypeFamilies,
  UndecidableInstances, GeneralizedNewtypeDeriving,
  MultiParamTypeClasses, FlexibleContexts, FlexibleInstances,
  PatternSynonyms, MagicHash, NoImplicitPrelude, DataKinds,
  BangPatterns, TypeApplications #-}
{-# OPTIONS_GHC -fno-warn-unused-imports#-}
{-# OPTIONS_GHC -fno-warn-duplicate-exports#-}
module Proto.Raft.Raft (Heartbeat(), Leader(), Stand(), Vote())
       where
import qualified Data.ProtoLens.Runtime.Control.DeepSeq
       as Control.DeepSeq
import qualified Data.ProtoLens.Runtime.Data.ProtoLens.Prism
       as Data.ProtoLens.Prism
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

{- | Fields :

    * 'Proto.Raft.Raft_Fields.term' @:: Lens' Heartbeat Data.Word.Word32@
 -}
data Heartbeat = Heartbeat{_Heartbeat'term :: !Data.Word.Word32,
                           _Heartbeat'_unknownFields :: !Data.ProtoLens.FieldSet}
                   deriving (Prelude.Eq, Prelude.Ord)
instance Prelude.Show Heartbeat where
        showsPrec _ __x __s
          = Prelude.showChar '{'
              (Prelude.showString (Data.ProtoLens.showMessageShort __x)
                 (Prelude.showChar '}' __s))
instance Data.ProtoLens.Field.HasField Heartbeat "term"
           (Data.Word.Word32)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Heartbeat'term
               (\ x__ y__ -> x__{_Heartbeat'term = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Message Heartbeat where
        messageName _ = Data.Text.pack "Heartbeat"
        fieldsByTag
          = let term__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "term"
                      (Data.ProtoLens.ScalarField Data.ProtoLens.UInt32Field ::
                         Data.ProtoLens.FieldTypeDescriptor Data.Word.Word32)
                      (Data.ProtoLens.PlainField Data.ProtoLens.Optional
                         (Data.ProtoLens.Field.field @"term"))
                      :: Data.ProtoLens.FieldDescriptor Heartbeat
              in
              Data.Map.fromList [(Data.ProtoLens.Tag 1, term__field_descriptor)]
        unknownFields
          = Lens.Family2.Unchecked.lens _Heartbeat'_unknownFields
              (\ x__ y__ -> x__{_Heartbeat'_unknownFields = y__})
        defMessage
          = Heartbeat{_Heartbeat'term = Data.ProtoLens.fieldDefault,
                      _Heartbeat'_unknownFields = ([])}
        parseMessage
          = let loop ::
                     Heartbeat -> Data.ProtoLens.Encoding.Bytes.Parser Heartbeat
                loop x
                  = do end <- Data.ProtoLens.Encoding.Bytes.atEnd
                       if end then
                         do let missing = [] in
                              if Prelude.null missing then Prelude.return () else
                                Prelude.fail
                                  (("Missing required fields: ") Prelude.++
                                     Prelude.show (missing :: ([Prelude.String])))
                            Prelude.return
                              (Lens.Family2.over Data.ProtoLens.unknownFields
                                 (\ !t -> Prelude.reverse t)
                                 x)
                         else
                         do tag <- Data.ProtoLens.Encoding.Bytes.getVarInt
                            case tag of
                                8 -> do y <- (Prelude.fmap Prelude.fromIntegral
                                                Data.ProtoLens.Encoding.Bytes.getVarInt)
                                               Data.ProtoLens.Encoding.Bytes.<?> "term"
                                        loop
                                          (Lens.Family2.set (Data.ProtoLens.Field.field @"term") y
                                             x)
                                wire -> do !y <- Data.ProtoLens.Encoding.Wire.parseTaggedValueFromWire
                                                   wire
                                           loop
                                             (Lens.Family2.over Data.ProtoLens.unknownFields
                                                (\ !t -> (:) y t)
                                                x)
              in
              (do loop Data.ProtoLens.defMessage)
                Data.ProtoLens.Encoding.Bytes.<?> "Heartbeat"
        buildMessage
          = (\ _x ->
               (let _v = Lens.Family2.view (Data.ProtoLens.Field.field @"term") _x
                  in
                  if (_v) Prelude.== Data.ProtoLens.fieldDefault then
                    Data.Monoid.mempty else
                    (Data.ProtoLens.Encoding.Bytes.putVarInt 8) Data.Monoid.<>
                      ((Data.ProtoLens.Encoding.Bytes.putVarInt) Prelude..
                         Prelude.fromIntegral)
                        _v)
                 Data.Monoid.<>
                 Data.ProtoLens.Encoding.Wire.buildFieldSet
                   (Lens.Family2.view Data.ProtoLens.unknownFields _x))
instance Control.DeepSeq.NFData Heartbeat where
        rnf
          = (\ x__ ->
               Control.DeepSeq.deepseq (_Heartbeat'_unknownFields x__)
                 (Control.DeepSeq.deepseq (_Heartbeat'term x__) (())))
{- | Fields :

    * 'Proto.Raft.Raft_Fields.id' @:: Lens' Leader Data.Text.Text@
 -}
data Leader = Leader{_Leader'id :: !Data.Text.Text,
                     _Leader'_unknownFields :: !Data.ProtoLens.FieldSet}
                deriving (Prelude.Eq, Prelude.Ord)
instance Prelude.Show Leader where
        showsPrec _ __x __s
          = Prelude.showChar '{'
              (Prelude.showString (Data.ProtoLens.showMessageShort __x)
                 (Prelude.showChar '}' __s))
instance Data.ProtoLens.Field.HasField Leader "id" (Data.Text.Text)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Leader'id
               (\ x__ y__ -> x__{_Leader'id = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Message Leader where
        messageName _ = Data.Text.pack "Leader"
        fieldsByTag
          = let id__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "id"
                      (Data.ProtoLens.ScalarField Data.ProtoLens.StringField ::
                         Data.ProtoLens.FieldTypeDescriptor Data.Text.Text)
                      (Data.ProtoLens.PlainField Data.ProtoLens.Optional
                         (Data.ProtoLens.Field.field @"id"))
                      :: Data.ProtoLens.FieldDescriptor Leader
              in Data.Map.fromList [(Data.ProtoLens.Tag 1, id__field_descriptor)]
        unknownFields
          = Lens.Family2.Unchecked.lens _Leader'_unknownFields
              (\ x__ y__ -> x__{_Leader'_unknownFields = y__})
        defMessage
          = Leader{_Leader'id = Data.ProtoLens.fieldDefault,
                   _Leader'_unknownFields = ([])}
        parseMessage
          = let loop :: Leader -> Data.ProtoLens.Encoding.Bytes.Parser Leader
                loop x
                  = do end <- Data.ProtoLens.Encoding.Bytes.atEnd
                       if end then
                         do let missing = [] in
                              if Prelude.null missing then Prelude.return () else
                                Prelude.fail
                                  (("Missing required fields: ") Prelude.++
                                     Prelude.show (missing :: ([Prelude.String])))
                            Prelude.return
                              (Lens.Family2.over Data.ProtoLens.unknownFields
                                 (\ !t -> Prelude.reverse t)
                                 x)
                         else
                         do tag <- Data.ProtoLens.Encoding.Bytes.getVarInt
                            case tag of
                                10 -> do y <- (do value <- do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
                                                              Data.ProtoLens.Encoding.Bytes.getBytes
                                                                (Prelude.fromIntegral len)
                                                  Data.ProtoLens.Encoding.Bytes.runEither
                                                    (case Data.Text.Encoding.decodeUtf8' value of
                                                         Prelude.Left err -> Prelude.Left
                                                                               (Prelude.show err)
                                                         Prelude.Right r -> Prelude.Right r))
                                                Data.ProtoLens.Encoding.Bytes.<?> "id"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"id") y x)
                                wire -> do !y <- Data.ProtoLens.Encoding.Wire.parseTaggedValueFromWire
                                                   wire
                                           loop
                                             (Lens.Family2.over Data.ProtoLens.unknownFields
                                                (\ !t -> (:) y t)
                                                x)
              in
              (do loop Data.ProtoLens.defMessage)
                Data.ProtoLens.Encoding.Bytes.<?> "Leader"
        buildMessage
          = (\ _x ->
               (let _v = Lens.Family2.view (Data.ProtoLens.Field.field @"id") _x
                  in
                  if (_v) Prelude.== Data.ProtoLens.fieldDefault then
                    Data.Monoid.mempty else
                    (Data.ProtoLens.Encoding.Bytes.putVarInt 10) Data.Monoid.<>
                      (((\ bs ->
                           (Data.ProtoLens.Encoding.Bytes.putVarInt
                              (Prelude.fromIntegral (Data.ByteString.length bs)))
                             Data.Monoid.<> Data.ProtoLens.Encoding.Bytes.putBytes bs))
                         Prelude.. Data.Text.Encoding.encodeUtf8)
                        _v)
                 Data.Monoid.<>
                 Data.ProtoLens.Encoding.Wire.buildFieldSet
                   (Lens.Family2.view Data.ProtoLens.unknownFields _x))
instance Control.DeepSeq.NFData Leader where
        rnf
          = (\ x__ ->
               Control.DeepSeq.deepseq (_Leader'_unknownFields x__)
                 (Control.DeepSeq.deepseq (_Leader'id x__) (())))
{- | Fields :

    * 'Proto.Raft.Raft_Fields.self' @:: Lens' Stand Leader@
    * 'Proto.Raft.Raft_Fields.maybe'self' @:: Lens' Stand (Prelude.Maybe Leader)@
    * 'Proto.Raft.Raft_Fields.term' @:: Lens' Stand Data.Word.Word32@
 -}
data Stand = Stand{_Stand'self :: !(Prelude.Maybe Leader),
                   _Stand'term :: !Data.Word.Word32,
                   _Stand'_unknownFields :: !Data.ProtoLens.FieldSet}
               deriving (Prelude.Eq, Prelude.Ord)
instance Prelude.Show Stand where
        showsPrec _ __x __s
          = Prelude.showChar '{'
              (Prelude.showString (Data.ProtoLens.showMessageShort __x)
                 (Prelude.showChar '}' __s))
instance Data.ProtoLens.Field.HasField Stand "self" (Leader) where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Stand'self
               (\ x__ y__ -> x__{_Stand'self = y__}))
              Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Field.HasField Stand "maybe'self"
           (Prelude.Maybe Leader)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Stand'self
               (\ x__ y__ -> x__{_Stand'self = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Field.HasField Stand "term"
           (Data.Word.Word32)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Stand'term
               (\ x__ y__ -> x__{_Stand'term = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Message Stand where
        messageName _ = Data.Text.pack "Stand"
        fieldsByTag
          = let self__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "self"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Leader)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'self"))
                      :: Data.ProtoLens.FieldDescriptor Stand
                term__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "term"
                      (Data.ProtoLens.ScalarField Data.ProtoLens.UInt32Field ::
                         Data.ProtoLens.FieldTypeDescriptor Data.Word.Word32)
                      (Data.ProtoLens.PlainField Data.ProtoLens.Optional
                         (Data.ProtoLens.Field.field @"term"))
                      :: Data.ProtoLens.FieldDescriptor Stand
              in
              Data.Map.fromList
                [(Data.ProtoLens.Tag 1, self__field_descriptor),
                 (Data.ProtoLens.Tag 2, term__field_descriptor)]
        unknownFields
          = Lens.Family2.Unchecked.lens _Stand'_unknownFields
              (\ x__ y__ -> x__{_Stand'_unknownFields = y__})
        defMessage
          = Stand{_Stand'self = Prelude.Nothing,
                  _Stand'term = Data.ProtoLens.fieldDefault,
                  _Stand'_unknownFields = ([])}
        parseMessage
          = let loop :: Stand -> Data.ProtoLens.Encoding.Bytes.Parser Stand
                loop x
                  = do end <- Data.ProtoLens.Encoding.Bytes.atEnd
                       if end then
                         do let missing = [] in
                              if Prelude.null missing then Prelude.return () else
                                Prelude.fail
                                  (("Missing required fields: ") Prelude.++
                                     Prelude.show (missing :: ([Prelude.String])))
                            Prelude.return
                              (Lens.Family2.over Data.ProtoLens.unknownFields
                                 (\ !t -> Prelude.reverse t)
                                 x)
                         else
                         do tag <- Data.ProtoLens.Encoding.Bytes.getVarInt
                            case tag of
                                10 -> do y <- (do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
                                                  Data.ProtoLens.Encoding.Bytes.isolate
                                                    (Prelude.fromIntegral len)
                                                    Data.ProtoLens.parseMessage)
                                                Data.ProtoLens.Encoding.Bytes.<?> "self"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"self") y
                                              x)
                                16 -> do y <- (Prelude.fmap Prelude.fromIntegral
                                                 Data.ProtoLens.Encoding.Bytes.getVarInt)
                                                Data.ProtoLens.Encoding.Bytes.<?> "term"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"term") y
                                              x)
                                wire -> do !y <- Data.ProtoLens.Encoding.Wire.parseTaggedValueFromWire
                                                   wire
                                           loop
                                             (Lens.Family2.over Data.ProtoLens.unknownFields
                                                (\ !t -> (:) y t)
                                                x)
              in
              (do loop Data.ProtoLens.defMessage)
                Data.ProtoLens.Encoding.Bytes.<?> "Stand"
        buildMessage
          = (\ _x ->
               (case
                  Lens.Family2.view (Data.ProtoLens.Field.field @"maybe'self") _x of
                    (Prelude.Nothing) -> Data.Monoid.mempty
                    Prelude.Just _v -> (Data.ProtoLens.Encoding.Bytes.putVarInt 10)
                                         Data.Monoid.<>
                                         (((\ bs ->
                                              (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                 (Prelude.fromIntegral (Data.ByteString.length bs)))
                                                Data.Monoid.<>
                                                Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                            Prelude.. Data.ProtoLens.encodeMessage)
                                           _v)
                 Data.Monoid.<>
                 (let _v = Lens.Family2.view (Data.ProtoLens.Field.field @"term") _x
                    in
                    if (_v) Prelude.== Data.ProtoLens.fieldDefault then
                      Data.Monoid.mempty else
                      (Data.ProtoLens.Encoding.Bytes.putVarInt 16) Data.Monoid.<>
                        ((Data.ProtoLens.Encoding.Bytes.putVarInt) Prelude..
                           Prelude.fromIntegral)
                          _v)
                   Data.Monoid.<>
                   Data.ProtoLens.Encoding.Wire.buildFieldSet
                     (Lens.Family2.view Data.ProtoLens.unknownFields _x))
instance Control.DeepSeq.NFData Stand where
        rnf
          = (\ x__ ->
               Control.DeepSeq.deepseq (_Stand'_unknownFields x__)
                 (Control.DeepSeq.deepseq (_Stand'self x__)
                    (Control.DeepSeq.deepseq (_Stand'term x__) (()))))
{- | Fields :

    * 'Proto.Raft.Raft_Fields.leader' @:: Lens' Vote Leader@
    * 'Proto.Raft.Raft_Fields.maybe'leader' @:: Lens' Vote (Prelude.Maybe Leader)@
 -}
data Vote = Vote{_Vote'leader :: !(Prelude.Maybe Leader),
                 _Vote'_unknownFields :: !Data.ProtoLens.FieldSet}
              deriving (Prelude.Eq, Prelude.Ord)
instance Prelude.Show Vote where
        showsPrec _ __x __s
          = Prelude.showChar '{'
              (Prelude.showString (Data.ProtoLens.showMessageShort __x)
                 (Prelude.showChar '}' __s))
instance Data.ProtoLens.Field.HasField Vote "leader" (Leader) where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Vote'leader
               (\ x__ y__ -> x__{_Vote'leader = y__}))
              Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Field.HasField Vote "maybe'leader"
           (Prelude.Maybe Leader)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _Vote'leader
               (\ x__ y__ -> x__{_Vote'leader = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Message Vote where
        messageName _ = Data.Text.pack "Vote"
        fieldsByTag
          = let leader__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "leader"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Leader)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'leader"))
                      :: Data.ProtoLens.FieldDescriptor Vote
              in
              Data.Map.fromList
                [(Data.ProtoLens.Tag 1, leader__field_descriptor)]
        unknownFields
          = Lens.Family2.Unchecked.lens _Vote'_unknownFields
              (\ x__ y__ -> x__{_Vote'_unknownFields = y__})
        defMessage
          = Vote{_Vote'leader = Prelude.Nothing, _Vote'_unknownFields = ([])}
        parseMessage
          = let loop :: Vote -> Data.ProtoLens.Encoding.Bytes.Parser Vote
                loop x
                  = do end <- Data.ProtoLens.Encoding.Bytes.atEnd
                       if end then
                         do let missing = [] in
                              if Prelude.null missing then Prelude.return () else
                                Prelude.fail
                                  (("Missing required fields: ") Prelude.++
                                     Prelude.show (missing :: ([Prelude.String])))
                            Prelude.return
                              (Lens.Family2.over Data.ProtoLens.unknownFields
                                 (\ !t -> Prelude.reverse t)
                                 x)
                         else
                         do tag <- Data.ProtoLens.Encoding.Bytes.getVarInt
                            case tag of
                                10 -> do y <- (do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
                                                  Data.ProtoLens.Encoding.Bytes.isolate
                                                    (Prelude.fromIntegral len)
                                                    Data.ProtoLens.parseMessage)
                                                Data.ProtoLens.Encoding.Bytes.<?> "leader"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"leader")
                                              y
                                              x)
                                wire -> do !y <- Data.ProtoLens.Encoding.Wire.parseTaggedValueFromWire
                                                   wire
                                           loop
                                             (Lens.Family2.over Data.ProtoLens.unknownFields
                                                (\ !t -> (:) y t)
                                                x)
              in
              (do loop Data.ProtoLens.defMessage)
                Data.ProtoLens.Encoding.Bytes.<?> "Vote"
        buildMessage
          = (\ _x ->
               (case
                  Lens.Family2.view (Data.ProtoLens.Field.field @"maybe'leader") _x
                  of
                    (Prelude.Nothing) -> Data.Monoid.mempty
                    Prelude.Just _v -> (Data.ProtoLens.Encoding.Bytes.putVarInt 10)
                                         Data.Monoid.<>
                                         (((\ bs ->
                                              (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                 (Prelude.fromIntegral (Data.ByteString.length bs)))
                                                Data.Monoid.<>
                                                Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                            Prelude.. Data.ProtoLens.encodeMessage)
                                           _v)
                 Data.Monoid.<>
                 Data.ProtoLens.Encoding.Wire.buildFieldSet
                   (Lens.Family2.view Data.ProtoLens.unknownFields _x))
instance Control.DeepSeq.NFData Vote where
        rnf
          = (\ x__ ->
               Control.DeepSeq.deepseq (_Vote'_unknownFields x__)
                 (Control.DeepSeq.deepseq (_Vote'leader x__) (())))