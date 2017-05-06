import Html exposing (div, text)

squareList : List Int -> List Int
squareList list =
  case list of
    [] -> []
    x :: xs -> x*x :: squareList xs

-- Implement this function to return the sum of all the elements in a list
sumList : List Int -> Int
sumList = Debug.crash "Not implemented yet"

-- Implement this function to reverse the order of the elements in a list
reverseList : List Int -> List Int
reverseList = Debug.crash "Not implemented yet"

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
