{-|
Copyright   : (c) 2018, Commonwealth Scientific and Industrial Research Organisation
License     : BSD3
Maintainer  : dave.laing.80@gmail.com
Stability   : experimental
Portability : non-portable
-}
{-# LANGUAGE OverloadedStrings #-}
module Workshop.Behavior.Querying.CounterText.Solution (
    counterTextSolution
  ) where

import Data.Text (Text)

import Reflex

import Workshop.Event.Filtering.FmapMaybe.Solution
import Workshop.Behavior.Querying.Counter.Solution

counterTextSolution :: Reflex t
                    => Behavior t Int
                    -> Behavior t Text
                    -> Event t ()
                    -> Event t ()
                    -> (Event t Text, Event t Int)
counterTextSolution bCount bText eAdd eReset =
  let
    (eError, eIn) =
      fmapMaybeSolution $ bText <@ eAdd
    eCount =
      counterSolution' bCount eIn eReset
  in
    (eError, eCount)
