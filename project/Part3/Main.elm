-- In this part we shall see how Elm handles I/O side effects.
-- Elm uses message-based communication with the "external world" (JavaScript)
-- through ports.
--
-- A port is a value/function defined through the keyword `port`, which produces
-- a value of type `Cmd`.
--
-- We shall define a port to save the notes via local storage. In the same way
-- we'll need to load the notes when the application starts. This could be done
-- through the `init` function.
port module Part3.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Part3.Note as Note

import Html exposing (Html, text)
import Part3.Note exposing (Note, mkNote)
import Styles exposing (..)
import Workshop exposing (..)

main =
  -- In order to receive values from the external world, we'll need to change
  -- the function which defines our `Program` to use `Html.programWithFlags`.
  -- This function is different from the `program` function only because `init`
  -- becomes a function which initializes the model through a parameter
  -- received from the external world.
  Html.program
    { init = pure init
    , update = update
    , view = view
    , subscriptions = always Sub.none
    }

---------------------------------------------------------------------- [ model ]
type alias Model =
  { notes : List Note
  , uid : Int
  , state : ModelState
  }

type ModelState
  = Viewing
  | Editing Int String

-- `init` must be a function which receives a list of notes.
init : Model
init =
  let
    fromList cs =
      List.foldr (\c (id, notes) -> (id + 1, mkNote id c :: notes)) (0, []) cs

    (uid, notes) = fromList ["Hello, world!", "Hello Elm!", "Hi FP"]
  in
    { notes = notes
    , uid = uid
    , state = Viewing
    }

--------------------------------------------------------------------- [ update ]
type Msg
  = Add
  | Focus Note
  | Input String
  | Commit

-- we'll need to return a command which saves notes in local storage when a
-- `Commit` operation is received.
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
      changeNoteById id content note =
        if note.id == id then { note | content = content } else note

      commit m =
        case m.state of
          Editing id content ->
            { m
            | notes =
                m.notes
                |> List.map (changeNoteById id content)
                |> List.filter (not << Note.isEmpty)
            }

          _ ->
            m

  in
    case msg of
      Add ->
        commit model
        |> \m ->
          { m
          | uid = m.uid + 1
          , notes = m.notes ++ [ mkNote m.uid "" ]
          , state = Editing m.uid ""
          }
        |> pure

      Focus note ->
        commit model
        |> \m -> { m | state = Editing note.id note.content }
        |> pure

      Commit ->
        commit model
        |> \m -> { m | state = Viewing }
        |> pure

      Input content ->
        case model.state of
          Editing id _ ->
            { model | state = Editing id content }
            |> pure

          _ ->
            model
            |> pure

----------------------------------------------------------------------- [ view ]
view : Model -> Html Msg
view model =
  let
    editingNoteHtml id content note =
      if note.id == id
        then noteEditHtml content note
        else noteViewHtml note

    notesHtml =
      case model.state of
        Viewing ->
          List.map noteViewHtml model.notes

        Editing id content ->
          List.map (editingNoteHtml id content) model.notes

  in
    H.div [ containerStyle ]
      [ H.div [] notesHtml
      , H.button [ E.onClick Add ] [ text "+" ]
      ]

noteViewHtml : Note -> Html Msg
noteViewHtml note =
  H.div
    [ E.onClick (Focus note)
    , noteStyle
    ]
    [ Note.toHtml note
    ]

noteEditHtml : String -> Note -> Html Msg
noteEditHtml content note =
  H.div [ noteStyle ]
    [ H.form [ E.onSubmit Commit ]
        [ H.input
            [ A.type_ "text"
            , A.value content
            , A.size 100
            , E.onInput Input
            ]
            []
        ]
    ]
