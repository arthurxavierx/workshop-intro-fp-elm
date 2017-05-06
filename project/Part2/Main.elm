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
-- Modifique o modelo da aplicação para que seja possível saber se alguma nota
-- está sendo editada. Adicione também ao modelo o número de identificação da
-- próxima nota a ser criada.

init : Model
init =
  List.map mkNote ["Hello, world!", "Hello Elm!", "Hi FP"]

--------------------------------------------------------------------- [ update ]
type Msg
  = Add
  -- Adicione novos valores no tipo Msg para permitir a edição de notas
  -- Precisaremos de 3 operações:
  -- - Focar uma nota:
  --    modificar um estado no modelo para que seja possível identificar
  --    qual nota está sendo editada;
  -- - Modificar o conteúdo:
  --    deve modificar um conteúdo temporário da nota em edição no modelo;
  -- - Salvar as alterações (commit):
  --    deve modificar a estrutura de dados com o novo conteúdo da nota editada.

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

-- Modifique a view para que sejam tratados os dois casos do estado do modelo:
-- quando alguma nota está sendo editada e quando nenhuma nota está sendo editada.
-- Recomenda-se a separação da função `noteHtml` em duas funções, uma para quando
-- a nota está sendo editada, e uma para quando está sendo visualizada.

noteHtml : Note -> Html Msg
noteHtml n =
  H.div [ noteStyle ] [ Note.toHtml n ]
