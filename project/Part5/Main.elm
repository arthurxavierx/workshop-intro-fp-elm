-- In this last part we'll parametrize the `Note` type over the type of its
-- content, so that we can change the content type at any moment, or even use
-- different types to represent the content of notes in the context of the
-- application and in the context of the database.
--
-- We'll use notes in the Markdown format in the application. For that, a helper
-- module `Final.Markdown` is defined. This module exposes the types and functions
-- needed to handle this format.
port module Part5.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Part5.Note as Note

import Html exposing (Html, text)
import Part5.Note exposing (Note, mkNote)
import Styles exposing (..)
import Workshop exposing (..)

type alias AppNote = Note Int
type alias StoredNote = Note ()

port saveNotes : List StoredNote -> Cmd a

main =
    Html.programWithFlags
      { init = pure << init
      , update = update
      , view = view
      , subscriptions = always Sub.none
      }

---------------------------------------------------------------------- [ model ]
type alias Model =
  { notes : List (Note Int)
  , uid : Int
  , state : ModelState Int
  }

type ModelState i
  = Viewing
  | Editing i String

init : List StoredNote -> Model
init notes =
  let
    consNoteWithNextId n (id, ns) =
      (id + 1, { n | id = id } :: ns)

    (uid, notesWithId) =
      List.foldr consNoteWithNextId (0, []) notes
  in
    { notes = notesWithId
    , uid = uid
    , state = Viewing
    }

--------------------------------------------------------------------- [ update ]
type Msg
  = Add
  | Focus AppNote
  | Input String
  | Commit

-- Deveremos modificar a função update para que o conteúdo seja serializado da
-- forma correta, isto é, para que o tipo `Note Int Markdown` seja convertido
-- para o formato serializável `Note () String`.

-- We'll have to modify the `update` function so that the content be serialized
-- in the right way. That is, so that the type `Note Int Markdown` be converted
-- to the serializable format `Note () String`.
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

      serialize = Note.mapId (always ())

      save f m = m ! [ saveNotes (f m.notes) ]

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
        |> save (List.map serialize)

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

noteViewHtml : AppNote -> Html Msg
noteViewHtml note =
  H.div
    [ E.onClick (Focus note)
    , noteStyle
    ]
    [ Note.toHtml note
    ]

noteEditHtml : String -> AppNote -> Html Msg
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
