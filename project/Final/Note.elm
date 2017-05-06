module Final.Note exposing (..)

import Html as H
import Html exposing (Html, text)

type alias Note i c =
  { id : i
  , content : c
  }

mkNote : i -> c -> Note i c
mkNote id content = { id = id, content = content }

map : (c -> d) -> Note i c -> Note i d
map f note = { note | content = f note.content }

mapId : (i -> j) -> Note i c -> Note j c
mapId f n = { n | id = f n.id }

isEmpty : Note i String -> Bool
isEmpty note = String.isEmpty (String.trim note.content)

toHtml : (c -> Html a) -> Note i c -> Html a
toHtml render {content} = H.div [] [ render content ]
