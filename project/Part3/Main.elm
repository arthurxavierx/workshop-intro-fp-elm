-- Nesta parte veremos como Elm trata efeitos colaterais de entrada e saída.
-- Elm utiliza comunicação via mensagens com o "mundo externo" (JavaScript)
-- através de ports.
--
-- Uma port é um valor/funçao definido com a keyword port que deve produzir um
-- valor do tipo Cmd.
--
-- Vamos definir uma port para salvar as notas via local storage. Da mesma forma
-- precisamos carregar as notas no início da aplicação. Isto pode ser feito
-- através da função init.
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
  -- Para que nossa aplicação possa receber valores do mundo externo, precisamos
  -- trocar a função que define o Program para Html.programWithFlags. A função
  -- programWithFlags difere da função program apenas no fato de que init vira
  -- uma função que inicializa o modelo a partir de um parâmetro recebido do
  -- mundo externo.
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

-- init deve ser uma função que recebe uma lista de notas.
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

-- precisaremos retornar um comando que salva as notas no local storage quando
-- uma operação de Commit é realizada.
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
