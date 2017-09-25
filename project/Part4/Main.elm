-- In this part we'll make the `Note` type polymorphic. That means it will be
-- parametrized by some other type. We shall modify it so that it can represent
-- both notes in the database as notes in the application.
--
-- Notes in the database shall not have an identification field, so that we can
-- optimize storage space.
--
-- One solution could be to parametrize the `Note` type over a type `i` which
-- represents the type of the identification field of a note. Thus, in the
-- context of the application, the type of the notes is `Note Int`, and in the
-- database, it is `Note ()`
port module Part4.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Part4.Note as Note

import Html exposing (Html, text)
import Part4.Note exposing (Note, mkNote)
import Styles exposing (..)
import Workshop exposing (..)

port saveNotes : List Note -> Cmd a

main =
  Html.programWithFlags
    { init = pure << init
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

-- In the `init` function, besides loading the notes, we'll need to map
-- unique identifiers to each note.
init : List Note -> Model
init notes =
  { notes = notes
  , uid = List.length notes
  , state = Viewing
  }

--------------------------------------------------------------------- [ update ]
type Msg
  = Add
  | Focus Note
  | Input String
  | Commit

-- As the type of notes will be polymorphic, we shall pass to the `update`
-- function a function which returns the next unique identifier to the
-- next possible note. This function should be used when of an `Add` message.
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
      changeNoteById id content note =
        if note.id == id then { note | content = content } else note

      commit m =
        case model.state of
          Editing id content ->
            { m
            | notes =
                m.notes
                |> List.map (changeNoteById id content)
                |> List.filter (not << Note.isEmpty)
            }

          _ ->
            m

      save m = m ! [ saveNotes m.notes ]

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
        |> save

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
