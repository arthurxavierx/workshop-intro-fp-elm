module Final.Markdown exposing (..)

import Html as H
import Html.Attributes as A
import Combine exposing (..)
import Html exposing (Html, text)

type MarkdownF
  = Text String
  | Link String
  | Image String String
  | Emph MarkdownF
  | Bold MarkdownF
  | Code MarkdownF

type Markdown = Markdown (List MarkdownF)

--------------------------------------------------------------------------------
toString : Markdown -> String
toString (Markdown ms) =
  let
    toStringF : MarkdownF -> String
    toStringF m = case m of
      Text s -> s
      Link s -> s
      Image alt uri -> "![" ++ alt ++ "](" ++ uri ++ ")"
      Emph m -> "_" ++ toStringF m ++ "_"
      Bold m -> "*" ++ toStringF m ++ "*"
      Code m -> "`" ++ toStringF m ++ "`"
  in
    List.foldr ((++) << toStringF) "" ms

toHtml : Markdown -> Html a
toHtml (Markdown ms) =
  let
    renderMarkdownF : MarkdownF -> Html a
    renderMarkdownF m = case m of
      Text s -> H.span [] [text s]
      Link s -> H.a [A.href s] [text s]
      Image alt uri -> H.img [ A.alt alt, A.src uri ] []
      Emph m -> H.em [] [renderMarkdownF m]
      Bold m -> H.strong [] [renderMarkdownF m]
      Code m -> H.code [] [renderMarkdownF m]
  in
    H.div [] <| List.foldr ((::) << renderMarkdownF) [] ms

fromString : String -> Markdown
fromString s = case parse parser s of
  Ok (_, _, result) -> result
  Err (_, _, errors) -> Markdown (List.map Text errors)

fromStringResult : String -> Result (List String) Markdown
fromStringResult s = case parse parser s of
  Ok (_, _, result) -> Ok result
  Err (_, _, errors) -> Err errors

parser : Parser s Markdown
parser =
  let
    text =
      Text <$> regex "[^\\*_`]+"
    link =
      Link <$> regex "(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?"
    image =
      string "!"
      *> brackets (Image <$> regex "[^\\]]+")
      <*> parens (regex "(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?")

    endString =
      (\_ -> "") <$> end
    betweenOrEnd s p =
      string s *> p <* (string s <|> endString)

    emph =
      lazy <| \_ -> Emph <$> betweenOrEnd "_" markdown
    bold =
      lazy <| \_ -> Bold <$> betweenOrEnd "*" markdown
    code =
      lazy <| \_ -> Code <$> betweenOrEnd "`" markdown

    markdown =
      lazy <| \_ -> choice [image, link, text, emph, bold, code]
  in
    Markdown <$> manyTill markdown end
