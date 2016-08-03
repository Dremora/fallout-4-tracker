module F4Tracker.Quest exposing (view, Model, init, Msg(..))

import Color as Color exposing (rgb)
import UI.Shared as Shared exposing (dim, vcenter)
import UI.Layout exposing (Element, fromText, space, toHtml, spaceRight, spaceLeft,
  onClick, cursor, Cursor(Pointer), auto, px, container, empty, center, lazy, stretch
  , flowDown, flowRight)
import UI.Text as Text exposing (bold, color, line, LineType(..), LineStyle(..), text, size)
import F4Tracker.Icons as Icons
import F4Tracker.Models exposing (Quest, Status(..))

import Debug

type alias Model = {
  quest : Quest
}

type Msg = UpdateStatus Quest Status


init quest = {
  quest = quest
  }


currentStatus =
  fromText << color (rgb 50 50 50) << size 12


anyStatus quest status =
  onClick (UpdateStatus quest status) << cursor Pointer << fromText << color (rgb 170 170 170) << size 12 << line Under Dashed


statusToggle quest status name =
  container auto auto stretch center
    <| spaceLeft 8
    <| (if quest.status == status then currentStatus else anyStatus quest status)
    <| text name

statusSwitcher quest =
  [ statusToggle quest NotStarted "Not started"
  , statusToggle quest InProgress "In progress"
  , statusToggle quest Completed "Completed"
  ]

view model =
  let
    view model =
      -- Debug.log "quest" <| 
      flowDown auto (px 35) [
             flowRight auto auto
              ([ spaceRight 6 <| icon model.quest
              , spaceRight 10 <| fromText <| questLabel model.quest <| text model.quest.name
              ]
              `List.append`
              statusSwitcher model.quest)
      , space 2 0 0 22 <| fromText <| color (rgb 160 160 160) <| size 12 <| text model.quest.category
      ]
  in
    lazy view model


questLabel quest =
    case quest.status of
        NotStarted ->
            identity

        InProgress ->
            bold

        Completed ->
            color (rgb 102 102 102) << line Through Solid


icon quest =
    case quest.status of
        NotStarted ->
            container (px 16) (px 16) center center <| empty

        InProgress ->
            Icons.circleONotch 16 (rgb 165 165 30)

        Completed ->
            Icons.check 16 Color.green
