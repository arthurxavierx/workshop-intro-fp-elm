import Html exposing (div, text)

greet : Bool -> String -> String
greet polite name =
  let
      greeting = if polite then "Hello" else "Yo"
  in
      greeting ++ " " ++ name ++ "!"

sayHello : String -> String
sayHello = greet True

sayYo : String -> String
sayYo = greet False

main =
  div []
    [ text <| sayHello "Dr. James"
    , text <| sayYo "brother"
    ]
