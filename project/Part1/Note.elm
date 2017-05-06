module Part1.Note exposing (..)

import Html as H
import Html exposing (Html, text)

type alias Note =
  { content : String
  }

mkNote : String -> Note
mkNote content = { content = content }

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
