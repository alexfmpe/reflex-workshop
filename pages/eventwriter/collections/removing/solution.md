```haskell
todoListModelSolution :: MonadWidget t m
                      => [TodoItem]
                      -> m (Dynamic t (Map Int TodoItem))
todoListModelSolution items = mdo
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem
  let
    eInsert = (\(k,v) -> k =: Just v) <$> eAdd
    m = Map.fromList . zip [0..] $ items
  (dmd          ) <-                   listHoldWithKey m eListChange $ \k item -> do
    (eChange, eRemove) <- todoItem item

    foldDyn ($) item eChange

  let
    eListChange = leftmost [          eInsert]

  pure $ joinDynThroughMap dmd
```
=====
We start with something like what we had before.
=====
```haskell
todoListModelSolution :: MonadWidget t m
                      => [TodoItem]
                      -> m (Dynamic t (Map Int TodoItem))
todoListModelSolution items = mdo
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem
  let
    eInsert = (\(k,v) -> k =: Just v) <$> eAdd
    m = Map.fromList . zip [0..] $ items
  (dmd          ) <-                   listHoldWithKey m eListChange $ \k item -> do
    (eChange, eRemove) <- todoItem item
    tellEvent $ k =: Nothing <$ eRemove
    foldDyn ($) item eChange

  let
    eListChange = leftmost [          eInsert]

  pure $ joinDynThroughMap dmd
```
=====
We use `tellEvent` to start accumulating a `listHoldWithKey`-compatible `Event` from all of the remove `Event`s in the collection.
=====
```haskell
todoListModelSolution :: MonadWidget t m
                      => [TodoItem]
                      -> m (Dynamic t (Map Int TodoItem))
todoListModelSolution items = mdo
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem
  let
    eInsert = (\(k,v) -> k =: Just v) <$> eAdd
    m = Map.fromList . zip [0..] $ items
  (dmd, eRemoves) <- runEventWriterT . listHoldWithKey m eListChange $ \k item -> do
    (eChange, eRemove) <- todoItem item
    tellEvent $ k =: Nothing <$ eRemove
    foldDyn ($) item eChange

  let
    eListChange = leftmost [eRemoves, eInsert]

  pure $ joinDynThroughMap dmd
```
=====
We then use `runEventWriterT` after `listHoldWithKey` to get hold of that combined `Event`.
