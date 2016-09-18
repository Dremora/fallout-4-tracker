module F4Tracker.Quest exposing (view, Model, init, Msg(..))

import Color as Color exposing (rgb)

import Html exposing (div, span, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Styles.Flexbox exposing (row, column, vcenter, hcenter, width, height, margin, padding)
import Styles.Text exposing (color, size, bold, line, LineType(..), LineStyle(..))

import F4Tracker.Icons as Icons
import F4Tracker.Models exposing (Quest, Status(..), categoryName)

type alias Model = {
  quest : Quest
}

type Msg = UpdateStatus Quest Status


init quest = {
  quest = quest
  }


currentStatus =
  [ color (rgb 50 50 50), size 12 ]


anyStatus quest status =
  [ onClick (UpdateStatus quest status), style [ ( "cursor", "pointer" ) ], color (rgb 170 170 170), size 12, line Under Dashed ]


statusToggle quest status name =
  let
    attributes = if quest.status == status then currentStatus else anyStatus quest status
  in
    div ([ row, vcenter, padding 0 0 0 8 ] `List.append` attributes) [ text name ]


statusSwitcher quest =
  [ statusToggle quest NotStarted "Not started"
  , statusToggle quest InProgress "In progress"
  , statusToggle quest Completed "Completed"
  ]

view model =
  div [ column, height 35 ] [
    div [ row ] ([
      div [ margin 0 6 0 0 ] [ icon model.quest ]
    , div [ margin 0 10 0 0 ] [ span (questLabel model.quest) [ text model.quest.name ] ]
    ] `List.append`
      statusSwitcher model.quest
    )
    , div [ padding 2 0 0 22 ] [ span [ color (rgb 160 160 160), size 12 ] [ text (categoryName model.quest) ] ]
  ]


questLabel quest =
    case quest.status of
        NotStarted ->
            []

        InProgress ->
            [ bold ]

        Completed ->
            [ color (rgb 102 102 102), line Through Solid ]


icon quest =
    case quest.status of
        NotStarted ->
            div [ row, vcenter, hcenter, width 16, height 16 ] [ ]

        InProgress ->
            Icons.circleONotch 16 (rgb 165 165 30)

        Completed ->
            Icons.check 16 Color.green
