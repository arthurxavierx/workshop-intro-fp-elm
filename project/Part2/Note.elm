module Part2.Note exposing (..)

import Html as H
import Html exposing (Html, text)

-- Modifique o tipo nota e suas operações para que seja possível identificar
-- unicamente uma nota. Recomenda-se a adição de um campo `id` inteiro.

type alias Note =
  { content : String
  }

mkNote : String -> Note
mkNote content = { content = content }

toHtml : Note -> Html a
toHtml {content} = H.span [] [ text content ]
