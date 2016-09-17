module F4Tracker.Icons exposing (search, circleONotch, check)

import Char
import String

import Html exposing (div, text)

import Styles.Flexbox exposing (row, vcenter, hcenter, width, height)
import Styles.Text exposing (font, color, size)


icon char textSize textColor =
  div [ row, vcenter, hcenter, width textSize, height textSize, font "FontAwesome", size textSize, color textColor ] [
    text (String.fromChar <| Char.fromCode char)
  ]


search =
    icon 61442


circleONotch =
    icon 61902


check =
    icon 61452
