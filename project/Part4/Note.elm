module Part4.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- O tipo Note deverá ser parametrizado em um tipo i que representa o tipo do
-- identificador único da nota, o campo id.
type alias Note =
  { id : Int
  , content : String
  }

-- Será útil definirmos uma função de alta ordem que aplica uma função de
-- conversão do tipo do identificador, um `mapId`.

mkNote : Int -> String -> Note
mkNote id content = { id = id, content = content }

isEmpty : Note -> Bool
isEmpty note = String.isEmpty (String.trim note.content)

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
