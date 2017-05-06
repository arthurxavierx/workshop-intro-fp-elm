import Html exposing (div, text)

greet : String -> Bool -> String
greet name polite =
  let
      greeting = if polite then "Hello" else "Yo"
  in
      greeting ++ " " ++ name ++ "!"

-- Implement this function using currying and the greet function.
-- You may have to change things elsewhere.
sayHello : String -> String
sayHello = Debug.crash "Not implemented yet"

-- Implement this function using currying and the greet function.
-- You may have to change things elsewhere.
sayYo : String -> String
sayYo = Debug.crash "Not implemented yet"

main =
  div []
    [ text <| sayHello "Dr. James"
    , text <| sayYo "brother"
    ]
