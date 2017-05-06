port module Final.Main exposing (..)

import Html as H
import Html.Attributes as A
import Html.Events as E
import Final.Note as Note
import Final.Markdown as Markdown

import Html exposing (Html, text)
import Final.Note exposing (Note, mkNote)
import Styles exposing (..)
import Workshop exposing (..)

type alias AppNote = Note Int Markdown.Markdown
type alias StoredNote = Note () String

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
  { notes : List AppNote
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
      let parsedContent = Markdown.fromString n.content
      in (id + 1, { n | id = id, content = parsedContent } :: ns)

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
                |> List.map (changeNoteById id (Markdown.fromString content))
                |> List.filter (not << Note.isEmpty << Note.map Markdown.toString)
            }

          _ ->
            m

      serialize = Note.map Markdown.toString << Note.mapId (always ())

      save f m = m ! [ saveNotes (f m.notes) ]

  in
    case msg of
      Add ->
        commit model
        |> \m ->
          { m
          | uid = m.uid + 1
          , notes = m.notes ++ [ mkNote m.uid (Markdown.fromString "") ]
          , state = Editing m.uid ""
          }
        |> pure

      Focus note ->
        commit model
        |> \m -> { m | state = Editing note.id (Markdown.toString note.content) }
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
    noteViewOrEditHtml id content note =
      if note.id == id
        then noteEditHtml content note
        else noteViewHtml note

    notesHtml =
      case model.state of
        Viewing ->
          List.map noteViewHtml model.notes

        Editing id content ->
          List.map (noteViewOrEditHtml id content) model.notes

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
    [ Note.toHtml Markdown.toHtml note
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
