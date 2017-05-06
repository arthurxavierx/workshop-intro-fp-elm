import Html exposing (ul, li, text)

factorial : Int -> Int
factorial = Debug.crash "Not implemented yet"

fibonacci : Int -> Int
fibonacci = Debug.crash "Not implemented yet"

main =
  ul []
    [ li [] [ text <| toString (factorial 8) ]
    , li [] [ text <| toString (fibonacci 11) ]
    ]
