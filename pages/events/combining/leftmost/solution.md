```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =








    (_    , _    , _        , _        )
```
=====
This should be fun.
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)





  in
    (_    , _    , _        , _        )
```
=====
We add a helper function in for working out if a number is a multiple of another number ...
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)
    eFizz = "Fizz" <$ ffilter (multiple 3) eIn




  in
    (eFizz, _    , _        , _        )
```
=====
... and then use this helper to define `eFizz` ...
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)
    eFizz = "Fizz" <$ ffilter (multiple 3) eIn
    eBuzz = "Buzz" <$ ffilter (multiple 5) eIn



  in
    (eFizz, eBuzz, _        , _        )
```
=====
... and `eBuzz`.
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)
    eFizz = "Fizz" <$ ffilter (multiple 3) eIn
    eBuzz = "Buzz" <$ ffilter (multiple 5) eIn
    eFizzBuzz = eFizz <> eBuzz


  in
    (eFizz, eBuzz, eFizzBuzz, _        )
```
=====
We use the `Monoid` instance for `Text` to combine these into `eFizzBuzz`.
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)
    eFizz = "Fizz" <$ ffilter (multiple 3) eIn
    eBuzz = "Buzz" <$ ffilter (multiple 5) eIn
    eFizzBuzz = eFizz <> eBuzz
    tshow = Text.pack . show

  in
    (eFizz, eBuzz, eFizzBuzz, _        )
```
=====
Now we add a helper for converting `Show`able values to `Text` ...
=====
```haskell
leftmostSolution :: Reflex t
                 => Event t Int
                 -> ( Event t Text
                    , Event t Text
                    , Event t Text
                    , Event t Text
                    )
leftmostSolution eIn =
  let
    multiple n = (== 0) . (`mod` n)
    eFizz = "Fizz" <$ ffilter (multiple 3) eIn
    eBuzz = "Buzz" <$ ffilter (multiple 5) eIn
    eFizzBuzz = eFizz <> eBuzz
    tshow = Text.pack . show
    eSolution = leftmost [eFizzBuzz, tshow <$> eIn]
  in
    (eFizz, eBuzz, eFizzBuzz, eSolution)
```
=====
... and we use that -- along with the prioritization that `leftmost` gives us -- to define `eSolution`.
