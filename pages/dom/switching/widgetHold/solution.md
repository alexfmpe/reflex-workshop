```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do














  _
```
=====
We're going to be generating our own click `Event`s now
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick







  _
```
=====
We start by generating `MonadWidget t m => m (Event t ())` widgets for each mode of operation.
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick

    ewMode = bool wReset wAdd <$> eClickable





  _
```
=====
We then build an `Event` which fires every time the mode of operation changes, and has the widget to use for that mode of operation as values.
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick

    ewMode = bool wReset wAdd <$> eClickable

  deScore <- widgetHold wReset ewMode



  _
```
=====
We use that with `widgetHold` to drive these DOM updates.
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick

    ewMode = bool wReset wAdd <$> eClickable

  deScore <- widgetHold wReset ewMode
  let
    eScore = switchDyn deScore

  _
```
=====
We then flatten the `Dynamic` of `Event`s to a single `Event`...
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick

    ewMode = bool wReset wAdd <$> eClickable

  deScore <- widgetHold wReset ewMode
  let
    eScore = switchDyn deScore

  foldDyn ($) 0 eScore
```
=====
... and collect them up into our output.
=====
```haskell
widgetHoldSolution :: MonadWidget t m
                   => Event t Bool
                   -> m (Dynamic t Int)
widgetHoldSolution eClickable = do
  let
    wReset = do
      eClick <- button "Wait..."
      pure $ const 0 <$ eClick
    wAdd = do
      eClick <- button "Click me"
      pure $ (+ 1) <$ eClick

    ewMode = bool wReset wAdd <$> eClickable

  dweMode <- holdDyn wReset ewMode
  eeScore <- dyn dweMode
  eScore  <- switchHold never eeScore

  foldDyn ($) 0 eScore
```
=====
We _could_ use `dyn` here, but it's more complicated and we should try to use `widgetHold` where we can anyhow.
