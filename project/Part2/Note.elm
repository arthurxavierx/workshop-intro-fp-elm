module Part2.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- Modify the `Note` type and its operations so that it be possible to
-- uniquely identify a note. It's recommended to add an integer field `id`.

type alias Note =
  { content : String
  }

mkNote : String -> Note
mkNote content = { content = content }

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
