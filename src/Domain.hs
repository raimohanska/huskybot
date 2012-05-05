{-# LANGUAGE DeriveDataTypeable #-}
module Domain where

import Data.Data
import Data.Typeable

data ChessBoard = ChessBoard { pieces :: [Piece]} deriving (Data, Typeable, Show)
data Piece = Piece { color :: String, position :: String} deriving (Data, Typeable, Show)
