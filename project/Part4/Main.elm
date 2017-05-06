-- Nesta parte tornaremos o tipo Note polimórfico. Devemos modificá-lo para que
-- ele possa representar tanto notas no banco de dados quando notas na aplicação.
--
-- As notas no banco de dados não devem possuir campo de identificação, para que
-- seja reduzido o espaço utilizado por elas.
--
-- Uma solução é parametrizar o tipo Note em relação a um tipo i que representa
-- o campo de identificação de uma nota. Para uma nota na aplicação, o tipo das
-- notas é `Note Int`, e para uma nota no banco de dados, `Note ()`.
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

-- Na função init será necessário, além de carregar as notas, mapear
-- identificadores únicos a cada nota.
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

-- Como o tipo nota será polimórfico, deveremos passar para a função update
-- uma função que retorna o próximo identificador único para a próxima nota
-- a ser criada, que deverá ser utilizada quando de uma mensagem Add.
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
