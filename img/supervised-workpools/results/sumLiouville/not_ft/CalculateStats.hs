module Main where

import System.Environment
import Data.List.Ordered

calcMedian :: [Float] -> Float
calcMedian vals =
  let ordered = sort vals
  in ordered !! (round $ (toRational (length vals) / 2.0))

calcLower vals = minimum vals

calcUpper vals = maximum vals

computeStats :: [Float] -> String
computeStats ls =
  let upper = calcUpper ls
      lower = calcLower ls
      median = calcMedian ls
  in (show median ++ " " ++ show lower ++ " " ++ show upper)


main = do
  args <- getArgs
  f <- readFile (args !! 0)
  let ls = map read (lines f)
  putStrLn (computeStats ls)


