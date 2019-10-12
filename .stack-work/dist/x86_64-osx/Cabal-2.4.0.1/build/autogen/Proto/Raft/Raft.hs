{- This file was auto-generated from raft/raft.proto by the proto-lens-protoc program. -}
{-# LANGUAGE ScopedTypeVariables, DataKinds, TypeFamilies,
  UndecidableInstances, GeneralizedNewtypeDeriving,
  MultiParamTypeClasses, FlexibleContexts, FlexibleInstances,
  PatternSynonyms, MagicHash, NoImplicitPrelude, DataKinds,
  BangPatterns, TypeApplications #-}
{-# OPTIONS_GHC -fno-warn-unused-imports#-}
{-# OPTIONS_GHC -fno-warn-duplicate-exports#-}
module Proto.Raft.Raft
       (Heartbeat(), Leader(), RaftMessage(), RaftMessage'Value(..),
        _RaftMessage'Heartbeat, _RaftMessage'Vote, _RaftMessage'Stand,
        _RaftMessage'Leader, Stand(), Vote())
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

    * 'Proto.Raft.Raft_Fields.maybe'value' @:: Lens' RaftMessage (Prelude.Maybe RaftMessage'Value)@
    * 'Proto.Raft.Raft_Fields.maybe'heartbeat' @:: Lens' RaftMessage (Prelude.Maybe Heartbeat)@
    * 'Proto.Raft.Raft_Fields.heartbeat' @:: Lens' RaftMessage Heartbeat@
    * 'Proto.Raft.Raft_Fields.maybe'vote' @:: Lens' RaftMessage (Prelude.Maybe Vote)@
    * 'Proto.Raft.Raft_Fields.vote' @:: Lens' RaftMessage Vote@
    * 'Proto.Raft.Raft_Fields.maybe'stand' @:: Lens' RaftMessage (Prelude.Maybe Stand)@
    * 'Proto.Raft.Raft_Fields.stand' @:: Lens' RaftMessage Stand@
    * 'Proto.Raft.Raft_Fields.maybe'leader' @:: Lens' RaftMessage (Prelude.Maybe Leader)@
    * 'Proto.Raft.Raft_Fields.leader' @:: Lens' RaftMessage Leader@
 -}
data RaftMessage = RaftMessage{_RaftMessage'value ::
                               !(Prelude.Maybe RaftMessage'Value),
                               _RaftMessage'_unknownFields :: !Data.ProtoLens.FieldSet}
                     deriving (Prelude.Eq, Prelude.Ord)
instance Prelude.Show RaftMessage where
        showsPrec _ __x __s
          = Prelude.showChar '{'
              (Prelude.showString (Data.ProtoLens.showMessageShort __x)
                 (Prelude.showChar '}' __s))
data RaftMessage'Value = RaftMessage'Heartbeat !Heartbeat
                       | RaftMessage'Vote !Vote
                       | RaftMessage'Stand !Stand
                       | RaftMessage'Leader !Leader
                           deriving (Prelude.Show, Prelude.Eq, Prelude.Ord)
instance Data.ProtoLens.Field.HasField RaftMessage "maybe'value"
           (Prelude.Maybe RaftMessage'Value)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude.. Prelude.id
instance Data.ProtoLens.Field.HasField RaftMessage
           "maybe'heartbeat"
           (Prelude.Maybe Heartbeat)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              Lens.Family2.Unchecked.lens
                (\ x__ ->
                   case x__ of
                       Prelude.Just (RaftMessage'Heartbeat x__val) -> Prelude.Just x__val
                       _otherwise -> Prelude.Nothing)
                (\ _ y__ -> Prelude.fmap RaftMessage'Heartbeat y__)
instance Data.ProtoLens.Field.HasField RaftMessage "heartbeat"
           (Heartbeat)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              (Lens.Family2.Unchecked.lens
                 (\ x__ ->
                    case x__ of
                        Prelude.Just (RaftMessage'Heartbeat x__val) -> Prelude.Just x__val
                        _otherwise -> Prelude.Nothing)
                 (\ _ y__ -> Prelude.fmap RaftMessage'Heartbeat y__))
                Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Field.HasField RaftMessage "maybe'vote"
           (Prelude.Maybe Vote)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              Lens.Family2.Unchecked.lens
                (\ x__ ->
                   case x__ of
                       Prelude.Just (RaftMessage'Vote x__val) -> Prelude.Just x__val
                       _otherwise -> Prelude.Nothing)
                (\ _ y__ -> Prelude.fmap RaftMessage'Vote y__)
instance Data.ProtoLens.Field.HasField RaftMessage "vote" (Vote)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              (Lens.Family2.Unchecked.lens
                 (\ x__ ->
                    case x__ of
                        Prelude.Just (RaftMessage'Vote x__val) -> Prelude.Just x__val
                        _otherwise -> Prelude.Nothing)
                 (\ _ y__ -> Prelude.fmap RaftMessage'Vote y__))
                Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Field.HasField RaftMessage "maybe'stand"
           (Prelude.Maybe Stand)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              Lens.Family2.Unchecked.lens
                (\ x__ ->
                   case x__ of
                       Prelude.Just (RaftMessage'Stand x__val) -> Prelude.Just x__val
                       _otherwise -> Prelude.Nothing)
                (\ _ y__ -> Prelude.fmap RaftMessage'Stand y__)
instance Data.ProtoLens.Field.HasField RaftMessage "stand" (Stand)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              (Lens.Family2.Unchecked.lens
                 (\ x__ ->
                    case x__ of
                        Prelude.Just (RaftMessage'Stand x__val) -> Prelude.Just x__val
                        _otherwise -> Prelude.Nothing)
                 (\ _ y__ -> Prelude.fmap RaftMessage'Stand y__))
                Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Field.HasField RaftMessage "maybe'leader"
           (Prelude.Maybe Leader)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              Lens.Family2.Unchecked.lens
                (\ x__ ->
                   case x__ of
                       Prelude.Just (RaftMessage'Leader x__val) -> Prelude.Just x__val
                       _otherwise -> Prelude.Nothing)
                (\ _ y__ -> Prelude.fmap RaftMessage'Leader y__)
instance Data.ProtoLens.Field.HasField RaftMessage "leader"
           (Leader)
         where
        fieldOf _
          = (Lens.Family2.Unchecked.lens _RaftMessage'value
               (\ x__ y__ -> x__{_RaftMessage'value = y__}))
              Prelude..
              (Lens.Family2.Unchecked.lens
                 (\ x__ ->
                    case x__ of
                        Prelude.Just (RaftMessage'Leader x__val) -> Prelude.Just x__val
                        _otherwise -> Prelude.Nothing)
                 (\ _ y__ -> Prelude.fmap RaftMessage'Leader y__))
                Prelude.. Data.ProtoLens.maybeLens Data.ProtoLens.defMessage
instance Data.ProtoLens.Message RaftMessage where
        messageName _ = Data.Text.pack "RaftMessage"
        fieldsByTag
          = let heartbeat__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "heartbeat"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Heartbeat)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'heartbeat"))
                      :: Data.ProtoLens.FieldDescriptor RaftMessage
                vote__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "vote"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Vote)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'vote"))
                      :: Data.ProtoLens.FieldDescriptor RaftMessage
                stand__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "stand"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Stand)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'stand"))
                      :: Data.ProtoLens.FieldDescriptor RaftMessage
                leader__field_descriptor
                  = Data.ProtoLens.FieldDescriptor "leader"
                      (Data.ProtoLens.MessageField Data.ProtoLens.MessageType ::
                         Data.ProtoLens.FieldTypeDescriptor Leader)
                      (Data.ProtoLens.OptionalField
                         (Data.ProtoLens.Field.field @"maybe'leader"))
                      :: Data.ProtoLens.FieldDescriptor RaftMessage
              in
              Data.Map.fromList
                [(Data.ProtoLens.Tag 1, heartbeat__field_descriptor),
                 (Data.ProtoLens.Tag 2, vote__field_descriptor),
                 (Data.ProtoLens.Tag 3, stand__field_descriptor),
                 (Data.ProtoLens.Tag 4, leader__field_descriptor)]
        unknownFields
          = Lens.Family2.Unchecked.lens _RaftMessage'_unknownFields
              (\ x__ y__ -> x__{_RaftMessage'_unknownFields = y__})
        defMessage
          = RaftMessage{_RaftMessage'value = Prelude.Nothing,
                        _RaftMessage'_unknownFields = ([])}
        parseMessage
          = let loop ::
                     RaftMessage -> Data.ProtoLens.Encoding.Bytes.Parser RaftMessage
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
                                                Data.ProtoLens.Encoding.Bytes.<?> "heartbeat"
                                         loop
                                           (Lens.Family2.set
                                              (Data.ProtoLens.Field.field @"heartbeat")
                                              y
                                              x)
                                18 -> do y <- (do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
                                                  Data.ProtoLens.Encoding.Bytes.isolate
                                                    (Prelude.fromIntegral len)
                                                    Data.ProtoLens.parseMessage)
                                                Data.ProtoLens.Encoding.Bytes.<?> "vote"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"vote") y
                                              x)
                                26 -> do y <- (do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
                                                  Data.ProtoLens.Encoding.Bytes.isolate
                                                    (Prelude.fromIntegral len)
                                                    Data.ProtoLens.parseMessage)
                                                Data.ProtoLens.Encoding.Bytes.<?> "stand"
                                         loop
                                           (Lens.Family2.set (Data.ProtoLens.Field.field @"stand") y
                                              x)
                                34 -> do y <- (do len <- Data.ProtoLens.Encoding.Bytes.getVarInt
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
                Data.ProtoLens.Encoding.Bytes.<?> "RaftMessage"
        buildMessage
          = (\ _x ->
               (case
                  Lens.Family2.view (Data.ProtoLens.Field.field @"maybe'value") _x of
                    (Prelude.Nothing) -> Data.Monoid.mempty
                    Prelude.Just
                      (RaftMessage'Heartbeat
                         v) -> (Data.ProtoLens.Encoding.Bytes.putVarInt 10) Data.Monoid.<>
                                 (((\ bs ->
                                      (Data.ProtoLens.Encoding.Bytes.putVarInt
                                         (Prelude.fromIntegral (Data.ByteString.length bs)))
                                        Data.Monoid.<> Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                    Prelude.. Data.ProtoLens.encodeMessage)
                                   v
                    Prelude.Just
                      (RaftMessage'Vote v) -> (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                 18)
                                                Data.Monoid.<>
                                                (((\ bs ->
                                                     (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                        (Prelude.fromIntegral
                                                           (Data.ByteString.length bs)))
                                                       Data.Monoid.<>
                                                       Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                                   Prelude.. Data.ProtoLens.encodeMessage)
                                                  v
                    Prelude.Just
                      (RaftMessage'Stand v) -> (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                  26)
                                                 Data.Monoid.<>
                                                 (((\ bs ->
                                                      (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                         (Prelude.fromIntegral
                                                            (Data.ByteString.length bs)))
                                                        Data.Monoid.<>
                                                        Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                                    Prelude.. Data.ProtoLens.encodeMessage)
                                                   v
                    Prelude.Just
                      (RaftMessage'Leader v) -> (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                   34)
                                                  Data.Monoid.<>
                                                  (((\ bs ->
                                                       (Data.ProtoLens.Encoding.Bytes.putVarInt
                                                          (Prelude.fromIntegral
                                                             (Data.ByteString.length bs)))
                                                         Data.Monoid.<>
                                                         Data.ProtoLens.Encoding.Bytes.putBytes bs))
                                                     Prelude.. Data.ProtoLens.encodeMessage)
                                                    v)
                 Data.Monoid.<>
                 Data.ProtoLens.Encoding.Wire.buildFieldSet
                   (Lens.Family2.view Data.ProtoLens.unknownFields _x))
instance Control.DeepSeq.NFData RaftMessage where
        rnf
          = (\ x__ ->
               Control.DeepSeq.deepseq (_RaftMessage'_unknownFields x__)
                 (Control.DeepSeq.deepseq (_RaftMessage'value x__) (())))
instance Control.DeepSeq.NFData RaftMessage'Value where
        rnf (RaftMessage'Heartbeat x__) = Control.DeepSeq.rnf x__
        rnf (RaftMessage'Vote x__) = Control.DeepSeq.rnf x__
        rnf (RaftMessage'Stand x__) = Control.DeepSeq.rnf x__
        rnf (RaftMessage'Leader x__) = Control.DeepSeq.rnf x__
_RaftMessage'Heartbeat ::
                       Data.ProtoLens.Prism.Prism' RaftMessage'Value Heartbeat
_RaftMessage'Heartbeat
  = Data.ProtoLens.Prism.prism' RaftMessage'Heartbeat
      (\ p__ ->
         case p__ of
             RaftMessage'Heartbeat p__val -> Prelude.Just p__val
             _otherwise -> Prelude.Nothing)
_RaftMessage'Vote ::
                  Data.ProtoLens.Prism.Prism' RaftMessage'Value Vote
_RaftMessage'Vote
  = Data.ProtoLens.Prism.prism' RaftMessage'Vote
      (\ p__ ->
         case p__ of
             RaftMessage'Vote p__val -> Prelude.Just p__val
             _otherwise -> Prelude.Nothing)
_RaftMessage'Stand ::
                   Data.ProtoLens.Prism.Prism' RaftMessage'Value Stand
_RaftMessage'Stand
  = Data.ProtoLens.Prism.prism' RaftMessage'Stand
      (\ p__ ->
         case p__ of
             RaftMessage'Stand p__val -> Prelude.Just p__val
             _otherwise -> Prelude.Nothing)
_RaftMessage'Leader ::
                    Data.ProtoLens.Prism.Prism' RaftMessage'Value Leader
_RaftMessage'Leader
  = Data.ProtoLens.Prism.prism' RaftMessage'Leader
      (\ p__ ->
         case p__ of
             RaftMessage'Leader p__val -> Prelude.Just p__val
             _otherwise -> Prelude.Nothing)
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