import Html exposing (ul, li, text)

factorial : Int -> Int
factorial x =
  if x <= 1 then
    1
  else
    x * factorial (x - 1)

fibonacci : Int -> Int
fibonacci =
  if x == 0 then
    0
  else if x == 1 then
    1
  else
    fibonacci (x - 1) + fibonacci (x - 2)

main =
  ul []
    [ li [] [ text <| toString (factorial 8) ]
    , li [] [ text <| toString (fibonacci 11) ]
    ]
