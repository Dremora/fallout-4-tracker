module F4Tracker.Icons exposing (search, circleONotch, check)

import UI.Shared exposing (colorToCss)
import Char
import String

import UI.Layout exposing (container, auto, px, center, fromText)
import UI.Text as Text exposing (text, font)

icon char size color =
  text (String.fromChar <| Char.fromCode char)
  |> font "FontAwesome"
  |> Text.size size
  |> Text.color color
  |> fromText
  |> container (px size) (px size) center center


search =
    icon 61442


circleONotch =
    icon 61902


check =
    icon 61452
