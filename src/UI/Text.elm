module UI.Text exposing (text, leftAligned, bold, color, size, weight, line
  , LineStyle(..), LineType(..), lineToCss, font, Text, toHtml, Line)

import Html
import Html.Attributes
import Color exposing (Color, toRgb)
import UI.Shared exposing (colorToCss)


type Text
  = Str String
  | Styled Style Text
  | Concat (List Text)


text : String -> Text
text =
  Str


empty : Text
empty =
  text ""


type alias Style =
  { weight : Maybe Int
  , size : Maybe Int
  , line : Maybe Line
  , color : Maybe Color
  , font : Maybe String
  }


defaultStyle : Style
defaultStyle =
  { weight = Nothing
  , size = Nothing
  , line = Nothing
  , color = Nothing
  , font = Nothing
  }


weight : Int -> Text -> Text
weight size text =
  case text of
    Styled style text ->
      Styled { style | weight = Just size } text
    _ ->
      Styled { defaultStyle | weight = Just size } text


bold =
  weight 700


size : Int -> Text -> Text
size px text =
  case text of
    Styled style text ->
      Styled { style | size = Just px } text
    _ ->
      Styled { defaultStyle | size = Just px } text



color : Color -> Text -> Text
color c text =
  case text of
    Styled style text ->
      Styled { style | color = Just c } text
    _ ->
      Styled { defaultStyle | color = Just c } text


font : String -> Text -> Text
font f text =
  case text of
    Styled style text ->
      Styled { style | font = Just f } text
    _ ->
      Styled { defaultStyle | font = Just f } text


type Line = Line LineType LineStyle (Maybe Color)
type LineType = Under | Over | Through
type LineStyle = Solid | Double | Dotted | Dashed | Wavy


line : LineType -> LineStyle -> Text -> Text
line lineType lineStyle text =
  case text of
    Styled style unstyledText ->
      case style.line of
        Just _ ->
          Styled { defaultStyle | line = Just (Line lineType lineStyle Nothing) } text
        Nothing ->
          Styled { style | line = Just (Line lineType lineStyle Nothing) } unstyledText
    _ ->
      Styled { defaultStyle | line = Just (Line lineType lineStyle Nothing) } text


lineToCss line =
  case line of
    Line Under _ _ ->
      "underline"

    Line Over _ _ ->
      "overline"

    Line Through _ _ ->
      "line-through"
  -- ++
  --   " "
  -- ++
  -- case line of
  --   Line _ Solid _ ->
  --     "solid"
  --   Line _ Double _ ->
  --     "double"
  --   Line _ Dotted _ ->
  --     "dotted"
  --   Line _ Dashed _ ->
  --     "dashed"
  --   Line _ Wavy _ ->
  --     "wavy"



stylesToCss styles =
  List.filterMap identity [
    Maybe.map (\w -> ("font-weight", toString w)) styles.weight
  , Maybe.map (\l -> ("text-decoration", lineToCss l)) styles.line
  , Maybe.map (\c -> ("color", colorToCss c)) styles.color
  , Maybe.map (\s -> ("font-size", toString s ++ "px")) styles.size
  , Maybe.map (\f -> ("font-family", f)) styles.font
  ]


toHtml text =
  case text of
    Str string ->
      Html.text string
    Styled styles text ->
      Html.span [ Html.Attributes.style <| stylesToCss styles ] [ toHtml text ]
    Concat list ->
      Html.span [ ] (List.map toHtml list)


leftAligned text =
  Html.div
      [ Html.Attributes.style
          [ ( "text-align", "left" )
          , ( "line-height", "1" )
          ]
      ]
      [ toHtml text ]