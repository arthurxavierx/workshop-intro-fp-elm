module Styles exposing (..)

import Html.Attributes as A
import Html exposing (Attribute)

containerStyle : Attribute a
containerStyle =
  A.style
    [ ("paddingTop", "2.4rem")
    , ("paddingLeft", "1.8rem")
    ]

noteStyle : Attribute a
noteStyle =
  A.style
    [ ("paddingTop", "0.6rem")
    , ("paddingBottom", "0.3rem")
    , ("marginLeft", "3.6rem")
    , ("display", "list-item")
    ]
