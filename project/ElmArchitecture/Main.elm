module Intro.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E

import Html exposing (Html, text)

main =
  Html.beginnerProgram
    { model = model
    , update = update
    , view = view
    }

---------------------------------------------------------------------- [ model ]
type alias Model = Int

model : Model
model = 0

--------------------------------------------------------------------- [ update ]
type Msg
  = Increment
  | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

----------------------------------------------------------------------- [ view ]
view :  Model -> Html Msg
view model =
  H.div []
    [ H.button [ E.onClick Decrement ] [ text "-" ]
    , H.h3 [] [ text (toString model) ]
    , H.button [ E.onClick Increment ] [ text "+" ]
    ]
