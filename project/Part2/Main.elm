port module Part2.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Part2.Note as Note

import Html exposing (Html, text)
import Part2.Note exposing (Note, mkNote)
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
-- Modify the model of the application in order to know if a note is being
-- edited. Also add to the model the identification number of the next note
-- to be created.

init : Model
init =
  List.map mkNote ["Hello, world!", "Hello Elm!", "Hi FP"]

--------------------------------------------------------------------- [ update ]
type Msg
  = Add
  -- Add new values to the Msg type to allow editing notes.
  -- We'll need 3 operations:
  -- - Focusing on a note:
  --    modify a state in the model to identify which note is being edited;
  -- - Modify the content:
  --    should modify a temporary content of the note currently being edited;
  -- - Save the changes (commit):
  --    should modify the data structure with the new content of the edited note.

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add ->
      model ++ [ mkNote "Lorem ipsum" ]
      |> pure

----------------------------------------------------------------------- [ view ]
view : Model -> Html Msg
view model =
  let
    notes = List.map noteHtml model
  in
    H.div [ containerStyle ]
      [ H.div [] notes
      , H.button [ E.onClick Add ] [ text "+" ]
      ]

-- Modify the view so that both model states be handled: when a note is being
-- edited and when none is.
-- It's recommended that one splits up the `noteHtml` function into two separate
-- functions: one for when a note is being edited and one for when it's viewed.

noteHtml : Note -> Html Msg
noteHtml n =
  H.div [ noteStyle ] [ Note.toHtml n ]
