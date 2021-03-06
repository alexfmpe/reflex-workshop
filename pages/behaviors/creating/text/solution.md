```haskell
textSolution :: (Reflex t, MonadFix m, MonadHold t m)
             => Behavior t Int
             -> Event t Text
             -> m (Behavior t [Text], Event t [Text])
textSolution bIn eIn = mdo


    
  b <- _
  pure (b, _)
```
=====
This is another case where we have an argument coming in as a `Behavior`.
=====
```haskell
textSolution :: (Reflex t, MonadFix m, MonadHold t m)
             => Behavior t Int
             -> Event t Text
             -> m (Behavior t [Text], Event t [Text])
textSolution bIn eIn = mdo
  let
    add n xs x = take n (x : xs)
    
  b <- _
  pure (b, _)
```
=====
If we can sort out what we want to do if we had all of the relevant values at a given instant ... 
=====
```haskell
textSolution :: (Reflex t, MonadFix m, MonadHold t m)
             => Behavior t Int
             -> Event t Text
             -> m (Behavior t [Text], Event t [Text])
textSolution bIn eIn = mdo
  let
    add n xs x = take n (x : xs)
    e = add <$> bIn <*> b <@> eIn
  b <- _
  pure (b, e)
```
=====
... there is usually a way to lift that into the network.
=====
```haskell
textSolution :: (Reflex t, MonadFix m, MonadHold t m)
             => Behavior t Int
             -> Event t Text
             -> m (Behavior t [Text], Event t [Text])
textSolution bIn eIn = mdo
  let
    add n xs x = take n (x : xs)
    e = add <$> bIn <*> b <@> eIn
  b <- hold [] e
  pure (b, e)
```
=====
After that we just need to decide on our initial conditions.
