module Part3.Note exposing (..)

import Html as H
import Html exposing (Html, text)

type alias Note =
  { id : Int
  , content : String
  }

mkNote : Int -> String -> Note
mkNote id content = { id = id, content = content }

isEmpty : Note -> Bool
isEmpty {content} = String.isEmpty (String.trim content)

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
