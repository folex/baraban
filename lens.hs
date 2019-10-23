{-# LANGUAGE TemplateHaskell, RankNTypes #-}

import Control.Lens

data Point = Point
    { _positionX :: Double
    , _positionY :: Double
    } deriving (Show)
makeLenses ''Point

data Segment = Segment
    { _segmentStart :: Point
    , _segmentEnd :: Point
    } deriving (Show)
makeLenses ''Segment

makePoint :: (Double, Double) -> Point
makePoint (x, y) = Point x y

makeSegment :: (Double, Double) -> (Double, Double) -> Segment
makeSegment start end = Segment (makePoint start) (makePoint end)

pointCoordinates :: Applicative f => (Double -> f Double) -> Point -> f Point
pointCoordinates g (Point x y) = Point <$> g x <*> g y

extremityCoordinates :: Applicative f => (Double -> f Double) -> Segment -> f Segment
extremityCoordinates g (Segment s e) = Segment <$> pointCoordinates g s <*> pointCoordinates g e

scaleSegment :: Double -> Segment -> Segment
scaleSegment mult s = over extremityCoordinates (\c -> c * mult) s

-- mapped :: Applicative f => (a -> f b) -> s -> f t
myMapped :: (Functor m) => (a -> Identity b) -> m a -> Identity (m b)
myMapped f ma = Identity $ fmap (runIdentity . f) ma

