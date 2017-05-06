import List
import Html exposing (div, text)

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

-- This type represents a shopping cart by a list of products and their quantities.
type alias Cart = List (Int, Product)

-- Some list utility functions may be used in the solution of this problem:
--
--   List.map : (a -> b) -> List a -> List b
--   List.reverse : List a -> List a
--   List.head : List a -> Maybe a

-- The total price can be calculated by calculating the discounted price for
-- each product, then calculating the total price for the quantities and then
-- summing it all up.
totalPrice : Cart -> Float
totalPrice = Debug.crash "Not implemented yet"

-- Calculate the most expensive item in the cart given its quantity.
mostExpensive : Cart -> Maybe Product
mostExpensive = Debug.crash "Not implemented yet"

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
