module Part5.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- The `Note` type shall be parametrized over a type `c` which represents the
-- type of the note's content, the `content` field.
type alias Note i =
  { id : i
  , content : String
  }

-- It will be useful to define a higher order function which applies a
-- function which converts the type of the content, a `map` function.

mkNote : i -> String -> Note i
mkNote id content = { id = id, content = content }

mapId : (i -> j) -> Note i -> Note j
mapId f n = { n | id = f n.id }

isEmpty : Note i -> Bool
isEmpty note = String.isEmpty (String.trim note.content)

toHtml : Note i -> Html a
toHtml {content} = H.span [] [ text content ]
