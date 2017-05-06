module Part5.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- O tipo Note deverá ser parametrizado em um tipo c que representa o tipo do
-- conteúdo da nota, o campo content.
type alias Note i =
  { id : i
  , content : String
  }

-- Será útil também definirmos uma função de alta ordem que aplica uma função
-- de conversão do tipo do conteúdo, um `map`.

mkNote : i -> String -> Note i
mkNote id content = { id = id, content = content }

mapId : (i -> j) -> Note i -> Note j
mapId f n = { n | id = f n.id }

isEmpty : Note i -> Bool
isEmpty note = String.isEmpty (String.trim note.content)

toHtml : Note i -> Html a
toHtml {content} = H.span [] [ text content ]
