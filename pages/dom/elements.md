
Now we'll start working with the DOM.
This means that we'll be starting to work with `reflex-dom` as well as `reflex` itself.

When we manipulate the DOM we work inside of a builder monad, and we access this builder monad through the `DomBuilder` typeclass.

There is also a collection of typeclass constraints called `MonadWidget` that includes all of the typeclasses we have seen so far (and a few which we'll see before too long), which can be really useful.

The widgets get added to the page in the order that they appear in our code.
This adds another reason for `RecursiveDo` to enter the scene: sometimes the elements we won't have a cycle in our network, but the order that the network is laid out in will be different to the order in which we connect the `Event`s and `Behavior`s.

The simplest thing we can add to the DOM is some text:
```haskell
text    :: DomBuilder t m 
        => Text 
        -> m ()
```

The next simplest thing we can do is to wrap an element around some other widget:
```haskell
el      :: DomBuilder t m 
        => Text 
        -> m a 
        -> m a
```

We can use that already:
```haskell
  el "div" $ 
    text "Testing text"
```

If things are going to change, we use `Dynamic`s to drive those changes.
That means we can create some state while still having the ability to trigger updates in the DOM.

For text that we want to update we have:
```haskell
dynText :: MonadWidget t m 
        => Dynamic t Text
        -> m ()
```
or, if we have something with a `Show` instance:
```haskell
display :: (MonadWidget t m, Show a)
        => Dynamic t a
        -> m ()
```

=====

There are a few variants on `el` that are useful.

We can specify a class (or classes) for elements with:
```haskell
elClass    :: MonadWidget t m 
           => Text 
           -> Text 
           -> m a 
           -> m a
```
or if they're going to be changing over time:
```haskell
elDynClass :: MonadWidget t m 
           => Text 
           -> Dynamic t Text 
           -> m a 
           -> m a
```

=====

We can specify attributes for elements with:
```haskell
elAttr    :: MonadWidget t m 
          => Text 
          -> Map Text Text 
          -> m a 
          -> m a
```
or if they're going to be changing over time:
```haskell
elDynAttr :: MonadWidget t m 
          => Text 
          -> Dynamic t (Map Text Text)
          -> m a 
          -> m a
```

There is a helper function which provides an inline version of `Map.singleton`:
```haskell
(=:) :: Ord k => k -> v -> Map k v
(=:) = Map.singleton
```
which we can use to get back to `elClass`:
```haskell
elClass :: MonadWidget t m 
        => Text 
        -> Text 
        -> m a 
        -> m a
elClass e c w =
  elAttr e ("class" =: c) w
```

=====

If you take any of the `elXYZ` functions and turn it into `elXYZ'`, it will return an additional value that you can use to hook into the DOMs event handling.

If we turn:
```haskell
el  :: MonadWidget t m 
    => Text 
    -> m a 
    -> m a
```
into:
```haskell
el' :: MonadWidget t m 
    => Text 
    -> m a 
    -> m (El, a)
```
we can use `domEvent` on the `El` value to create a `reflex` `Event`:
```haskell
clickMe :: MonadWidget t m 
        => m (Event t ())
clickMe = do
  (e, _) <- el' "div" (text "Click me")
  pure (domEvent Click e)
```

=====

There is a button input built-in to `reflex-dom`

```haskell
button :: DomBuilder t m 
       => Text 
       -> m (Event t ())
```

In `src/Util/Bootstrap.hs`, we have:
```haskell
buttonClass :: MonadWidget t m 
            => Text 
            -> Text 
            -> m (Event t ())
```
to give you clickable `div`s.

If you use `buttonClass "Click me" "btn"` you'll get a Bootstrap-styled `div`-based button, if that's something you'd prefer.

=====

There is also a `reflex-dom` component for clickable links:
```haskell
link      :: DomBuilder t m 
          => Text 
          -> m (Link t)

linkClass :: DomBuilder t m 
          => Text 
          -> Text 
          -> m (Link t)
```

The `Link` type is the first data structure we've come across for managing a `reflex-dom` component:
```haskell
newtype Link t = Link { _link_clicked :: Event t () }
```

It contains one value, which is the click `Event`, and we can access that value via the supplied `lens` like so:
```haskell
  l <- link "Click me"
  pure $ view link_clicked l
```
or in the operator form:
```haskell
  l <- link "Click me"
  pure $ l ^. link_clicked
```

We'll be seeing more of these built-in components and data structures in the next section.

Before that, we'll start creating one of our own.

=====
