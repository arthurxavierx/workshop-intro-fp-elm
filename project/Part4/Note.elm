module Part4.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- The `Note` type shall be parametrized over a type `i` which represents the
-- type of the note's unique identifier, the `id` field.
type alias Note =
  { id : Int
  , content : String
  }

-- It will be useful to define a higher order function which applies a
-- function which converts the type of the identifier, a `mapId` function.

mkNote : Int -> String -> Note
mkNote id content = { id = id, content = content }

isEmpty : Note -> Bool
isEmpty note = String.isEmpty (String.trim note.content)

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
