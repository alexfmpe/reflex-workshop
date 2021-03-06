```haskell
addItem :: MonadWidget t m
        => m (Event t TodoItem)
addItem =  do
  ti <- textInput $
    def

  let
    eEnter    = keypress Enter ti
    bText     = current $ value ti
    eStripped = Text.strip <$> bText <@ eEnter
    eText     = ffilter (not . Text.null) eStripped
    eAdd      = TodoItem False <$> eText

  pure eAdd
```
=====
The widget for adding items is already doing something vary similar to our text inputs for the TODO item edits.
=====
```haskell
addItem :: MonadWidget t m
        => m (Event t TodoItem)
addItem = mdo
  ti <- textInput $
    def & setValue .~ ("" <$ eEnter)

  let
    eEnter    = keypress Enter ti
    bText     = current $ value ti
    eStripped = Text.strip <$> bText <@ eEnter
    eText     = ffilter (not . Text.null) eStripped
    eAdd      = TodoItem False <$> eText

  pure eAdd
```
=====
We just need to use `RecursiveDo` to clear the inputs on Enter.
=====
```haskell
todoListSolution :: MonadWidget t m
                 => [TodoItem]
                 -> m ()
todoListSolution items = do



  let
    m = Map.fromList . zip [0..] $ items
  void . listHoldWithKey m never   $ 
    const todoItem
```
=====
We then take our existing code ...
=====
```haskell
todoListSolution :: MonadWidget t m
                 => [TodoItem]
                 -> m ()
todoListSolution items = do
  eItem <- addItem


  let
    m = Map.fromList . zip [0..] $ items
  void . listHoldWithKey m never   $ 
    const todoItem
```
=====
... and add the `addItem` widget to it.
=====
```haskell
todoListSolution :: MonadWidget t m
                 => [TodoItem]
                 -> m ()
todoListSolution items = do
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem

  let
    m = Map.fromList . zip [0..] $ items
  void . listHoldWithKey m never   $ 
    const todoItem
```
=====
We want unique IDs for these items, so we count the number of additions that we see, starting at the length of the input list.
=====
```haskell
todoListSolution :: MonadWidget t m
                 => [TodoItem]
                 -> m ()
todoListSolution items = do
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem
  let
    eInsert = (\(k,v) -> k =: Just v) <$> eAdd
    m = Map.fromList . zip [0..] $ items
  void . listHoldWithKey m never   $ 
    const todoItem
```
=====
We then turn that into an `Event` of the right form for `listHoldWithKey` ...
=====
```haskell
todoListSolution :: MonadWidget t m
                 => [TodoItem]
                 -> m ()
todoListSolution items = do
  eItem <- addItem
  eAdd  <- numberOccurrencesFrom (length items) eItem
  let
    eInsert = (\(k,v) -> k =: Just v) <$> eAdd
    m = Map.fromList . zip [0..] $ items
  void . listHoldWithKey m eInsert $ 
    const todoItem
```
=====
... and pass it in.
 
