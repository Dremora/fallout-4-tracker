module Styles.Text exposing (..)

import Color exposing (Color, toRgb)
import Html.Attributes exposing (style)


font fontName =
  style
    [ ( "font-family", fontName )
    ]

weight number =
  style
    [ ( "font-weight", toString number )
    ]

bold =
  weight 700

size px =
  style
    [ ( "font-size", toString px ++ "px" )
    ]

color c =
  style
    [ ( "color", colorToCss c )
    ]

colorToCss color =
  case toRgb color of
    { red, green, blue, alpha } ->
      "rgba(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ "," ++ toString alpha ++ ")"



-- type Line = Line LineType LineStyle (Maybe Color)
type LineType = Under | Over | Through
type LineStyle = Solid | Double | Dotted | Dashed | Wavy


lineToCss lineType lineStyle =
  case lineType of
    Under ->
      "underline"

    Over ->
      "overline"

    Through ->
      "line-through"


line lineType lineStyle =
  style [
    ( "text-decoration", lineToCss lineType lineStyle )
  ]