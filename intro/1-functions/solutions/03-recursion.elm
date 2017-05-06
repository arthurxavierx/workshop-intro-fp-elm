import Html exposing (div, text)

squareList : List Int -> List Int
squareList list =
  case list of
    [] -> []
    x :: xs -> x*x :: squareList xs

sumList : List Int -> Int
sumList list =
  case list of
    [] -> 0
    x :: xs -> x + sumList xs

reverseList : List Int -> List Int
reverseList list =
  case list of
    [] -> []
    x :: xs -> reverseList xs ++ [x]

main =
  let
    l = [10, 5, 1, 6, 2, 3, 11, 4]
  in
    div []
      [ div [] [ text <| "l = " ++ toString l ]
      , div [] [ text <| "square(l) = " ++ toString (squareList l) ]
      , div [] [ text <| "sum(l) = " ++ toString (sumList l) ]
      , div [] [ text <| "reverse(l) = " ++ toString (reverseList l) ]
      ]
