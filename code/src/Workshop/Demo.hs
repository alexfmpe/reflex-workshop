{-|
Copyright   : (c) 2018, Commonwealth Scientific and Industrial Research Organisation
License     : BSD3
Maintainer  : dave.laing.80@gmail.com
Stability   : experimental
Portability : non-portable
-}
{-# LANGUAGE OverloadedStrings #-}
module Workshop.Demo (
    demoSection
  ) where

import Reflex.Dom.Core

import Util.Exercises
import Util.File
import Util.Section

import Workshop.Demo.Problems.Toggle

demoSection :: MonadWidget t m => Section t m
demoSection =
  Section "Workshop Demo" [
      SubSection "Testing out the workshop code" $ \is -> do
        [a, b] <- loadMarkdownSplices "../pages/demo.md"
        a
        es <- runProblem 0 is $ toggleProblem
        b
        pure es
    ]
