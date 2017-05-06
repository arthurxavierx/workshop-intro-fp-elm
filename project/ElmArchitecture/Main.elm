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
type alias Model = { value : Int }

model : Model
model = { value = 0 }

--------------------------------------------------------------------- [ update ]
type Msg
  = Increment
  | Decrement

update : Msg -> Model -> Model
update msg model =
  let
    inc x = x + 1
    dec = (+) 1

    cycle m x = x % m
    cycleIf m x =
      if x >= m then
        0
      else if x < 0 then
        m - 1
      else
        x
  in
    case msg of
      Increment ->
        { model | value = cycle 10 <| inc model.value }

      Decrement ->
        { model
        | value =
            model.value
            |> dec
            |> cycleIf 10
        }

----------------------------------------------------------------------- [ view ]
view :  Model -> Html Msg
view {value} =
  H.div []
    [ H.button [ E.onClick Decrement ] [ text "-" ]
    , H.h3 [] [ text (toString value) ]
    , H.button [ E.onClick Increment ] [ text "+" ]
    ]
