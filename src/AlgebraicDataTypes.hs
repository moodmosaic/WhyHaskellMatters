module AlgebraicDataTypes where

import Control.Monad ((>=>))

-- a simple sum type
data Status = Green | Yellow | Red deriving (Eq, Show)

-- a simple product type
data Pair a b = P a b deriving (Show)

data Tree a = Leaf a | Node (Tree a) (Tree a) deriving (Show)

--data Maybe a = Just a | Nothing deriving (Eq, Show)

findValue :: String -> [(String, a)] -> Maybe a
findValue = lookup

safeDiv :: (Eq a, Fractional a) => a -> a -> Maybe a
safeDiv _ 0 = Nothing
safeDiv x y = Just (x / y)

safeRoot :: (Ord a, Floating a) => a -> Maybe a
safeRoot x
  | x < 0     = Nothing
  | otherwise = Just (sqrt x)

findDivRoot :: Double -> String -> [(String, Double)] -> Maybe Double
findDivRoot x key map =
  case findValue key map of
      Nothing -> Nothing
      Just y  -> case safeDiv x y of
          Nothing -> Nothing
          Just d  -> case safeRoot d of
              Nothing -> Nothing
              Just r  -> Just r

findDivRoot' x key map =
  findValue key map >>= \y ->
  safeDiv x y       >>= \d ->
  safeRoot d

findDivRoot'' x key map = 
  findValue key map >>=
  (safeDiv x >=>
  safeRoot)
  
findDivRoot''' x key map = do
  y <- findValue key map
  d <- safeDiv x y
  safeRoot d
  