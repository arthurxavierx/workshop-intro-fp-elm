import List
import Html exposing (div, h4, text)

type alias Product =
  { name : String
  , price : Float
  , discount : Float  -- in %
  }

potato = { name = "Potato", price = 0.5, discount = 0.0 }
apple = { name = "Apple", price = 0.2, discount = 0.0 }
pen = { name = "Pen", price = 1.0, discount = 0.1 }
tshirt = { name = "T-Shirt", price = 10.0, discount = 0.15 }
phone = { name = "Phone", price = 100.0, discount = 0.15 }
book = { name = "Book", price = 20.0, discount = 0.05 }

type alias Cart = List (Int, Product)

price : Product -> Float
price product = product.price * (1 - product.discount)

priceQnt : (Int, Product) -> Float
priceQnt (q, product) = toFloat q * price product

totalPrice : Cart -> Float
totalPrice =
  let
    sum list =
      case list of
        [] -> 0
        x :: xs -> x + sum xs
  in
    sum << List.map priceQnt

mostExpensive : Cart -> Maybe Product
mostExpensive list =
  let
    tagWithPrice product = (product, priceQnt product)
    maxList list =
      case list of
        [] -> 0
        x :: xs -> x + maxList xs
  in
    list
    |> List.sortBy priceQnt
    |> List.reverse
    |> List.map Tuple.second
    |> List.head

main =
  let
    bridget =
      [ (3, potato)
      , (1, book)
      , (1, pen)
      , (2, tshirt)
      ]
    richard =
      [ (4, potato)
      , (2, apple)
      , (1, phone)
      , (1, tshirt)
      , (1, book)
      ]

    cartHtml name cart =
      div []
        [ h4 [] [ text (name ++ "'s cart") ]
        , div []
          [ div [] [ text <| "Cart: " ++ toString cart ]
          , div [] [ text <| "Total price: " ++ toString (totalPrice cart) ]
          , div [] [ text <| "Most expensive item: " ++ toString (mostExpensive cart) ]
          ]
        ]
  in
    div []
      [ cartHtml "Bridget" bridget
      , cartHtml "Richard" richard
      ]
