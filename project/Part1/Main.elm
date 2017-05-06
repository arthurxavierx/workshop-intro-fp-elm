port module Part1.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Part1.Note as Note

import Html exposing (Html, text)
import Part1.Note exposing (Note, mkNote)
import Styles exposing (..)
import Workshop exposing (..)

main =
  Html.program
    { init = pure init
    , update = update
    , view = view
    , subscriptions = always Sub.none
    }

---------------------------------------------------------------------- [ model ]
type alias Model = List Note

init : Model
init =
  [ -- Insira algumas notas aqui
  ]

--------------------------------------------------------------------- [ update ]
type Msg = Add

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add ->
      pure model -- Modifique isto para inserir novas notas ao final da lista

----------------------------------------------------------------------- [ view ]
view : Model -> Html Msg
view model =
  H.div [ containerStyle ]
    -- Modifique isto para mostrar as notas dentro do container
    [ H.div [] [ text "Notes go here" ]
    , H.button [ E.onClick Add ] [ text "+" ]
    ]

noteHtml : Note -> Html Msg
noteHtml n =
  H.div [ noteStyle ] [ Note.toHtml n ]
