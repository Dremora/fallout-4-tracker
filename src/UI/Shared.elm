module UI.Shared
    exposing
        ( borderBottom
        , center
        , flowDown
        , dim
        , emptyElement
        , fill
        , padding
        , grow
        , hcenter
        , idElement
        , maxWidth
        , flowRight
        , vcenter
        , viewport
        , vscroll
        , colorToCss
        )

import Html
import Html.Attributes exposing (style)
import Color exposing (toRgb)


boxStyles =
    style
        [ ( "display", "flex" )
        , ( "border-width", "0" )
        , ( "border-style", "solid" )
        , ( "box-sizing", "border-box" )
        , ( "flex-shrink", "0" )
        , ( "flex-grow", "0" )
        , ( "flex-direction", "column" )
        ]


grow number contents =
    Html.div
        [ boxStyles
        , style
            [ ( "flex-grow", toString number )
            ]
        ]
        [ contents ]


rowStyles =
    style
        [ ( "flex-direction", "row" )
        ]


flowRight contents =
    Html.div [ boxStyles, rowStyles ] contents


-- rowEntryStyles =
--     style
--         [ ( "flex-grow", "0" )
--         ]
--
--
-- rowEntry contents =
--     Html.div [ boxStyles, rowEntryStyles ] [ contents ]


colStyles =
    style
        [ ( "flex-direction", "column" )
        ]


flowDown contents =
    Html.div [ boxStyles, colStyles ] contents


-- columnEntryStyles =
--     style
--         [ ( "flex-grow", "0" )
--         ]


-- columnEntry contents =
--     Html.div [ boxStyles, columnEntryStyles ] [ contents ]


hcenterStyles =
    style
        [ ( "align-items", "center" )
        ]


hcenter contents =
    Html.div [ boxStyles, hcenterStyles ] [ hcenterContents contents ]


hcenterContentsStyles =
    style
        [ ( "flex-grow", "0" )
        ]


hcenterContents contents =
    Html.div [ boxStyles, hcenterContentsStyles ] [ contents ]


vcenter contents =
    Html.div [ boxStyles, rowStyles, hcenterStyles ] [ contents ]


-- vcenterContentsStyles =
--     style
--         [ ( "flex-grow", "0" )
--         ]


-- vcenterContents contents =
--     Html.div [ boxStyles, vcenterContentsStyles ] [ contents ]


center =
    hcenter >> vcenter


padding top right bottom left contents =
    Html.div
        [ boxStyles
        , style
            [ ( "padding-top", (toString top) ++ "px" )
            , ( "padding-right", (toString right) ++ "px" )
            , ( "padding-bottom", (toString bottom) ++ "px" )
            , ( "padding-left", (toString left) ++ "px" )
            ]
        ]
        [ contents ]


dim width height contents =
    Html.div
        [ boxStyles
        , style
            [ ( "width"
              , if width == "auto" then
                    width
                else
                    width ++ "px"
              )
            , ( "height"
              , if height == "auto" then
                    height
                else
                    height ++ "px"
              )
            ]
        ]
        [ contents ]


viewportStyles =
    style
        [ ( "width", "100vw" )
        , ( "height", "100vh" )
        ]


viewport contents =
    Html.div [ boxStyles, viewportStyles ] [ contents ]


vscrollStyles =
    style
        [ ( "overflow-y", "auto" )
        ]


vscroll contents =
    Html.div [ boxStyles, vscrollStyles ] [ contents ]


borderBottom width color contents =
    Html.div
        [ boxStyles
        , style
            [ ( "border-bottom-width", toString width ++ "px" )
            , ( "border-bottom-color", color )
            ]
        ]
        [ contents ]


maxWidth width contents =
    Html.div
        [ boxStyles
        , style
            [ ( "max-width", toString width ++ "px" )
            , ( "flex-grow", "0" )
            ]
        ]
        [ contents ]


fill color contents =
    Html.div
        [ boxStyles
        , style
            [ ( "background-color", color )
            ]
        ]
        [ contents ]


idElement contents =
    Html.div [ boxStyles ] [ contents ]


emptyElement =
    Html.div [ boxStyles ] []


colorToCss color =
  case toRgb color of
    { red, green, blue, alpha } ->
      "rgba(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ "," ++ toString alpha ++ ")"
