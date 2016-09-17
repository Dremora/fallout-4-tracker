module Styles.Flexbox exposing (..)

import Html.Attributes exposing (style)


row =
  style
    [ ( "display", "flex" )
    , ( "border-width", "0" )
    , ( "border-style", "solid" )
    , ( "box-sizing", "border-box" )
    , ( "position", "relative" )
    , ( "flex-shrink", "0" )
    , ( "flex-grow", "0" )
    , ( "flex-direction", "row" )
    , ( "align-items", "stretch" )
    ]

column =
  style
    [ ( "display", "flex" )
    , ( "border-width", "0" )
    , ( "border-style", "solid" )
    , ( "box-sizing", "border-box" )
    , ( "position", "relative" )
    , ( "flex-shrink", "0" )
    , ( "flex-grow", "0" )
    , ( "flex-direction", "column" )
    , ( "align-items", "stretch" )
    ]


vcenter =
  style
    [ ( "align-items", "center" )
    ]

hcenter =
  style
    [ ( "justify-content", "center" )
    ]

padding top right bottom left =
  style
    [ ( "padding-top", (toString top) ++ "px" )
    , ( "padding-right", (toString right) ++ "px" )
    , ( "padding-bottom", (toString bottom) ++ "px" )
    , ( "padding-left", (toString left) ++ "px" )
    ]

margin top right bottom left =
  style
    [ ( "margin-top", (toString top) ++ "px" )
    , ( "margin-right", (toString right) ++ "px" )
    , ( "margin-bottom", (toString bottom) ++ "px" )
    , ( "margin-left", (toString left) ++ "px" )
    ]

width number =
  style
    [ ( "width", (toString number) ++ "px" )
    ]

height number =
  style
    [ ( "height", (toString number) ++ "px" )
    ]
