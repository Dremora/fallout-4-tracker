module F4Tracker.Main exposing (..)

import String
import Color exposing (rgb)
import Task
import Html.App exposing (map)

import UI.Shared
    exposing
        ( flowRight
        , flowDown
        , padding
        , vcenter
        , hcenter
        , center
        , vscroll
        , borderBottom
        , maxWidth
        , fill
        , viewport
        , dim
        )
import UI.Input as Input
import UI.Layout as Layout exposing (toHtml, lazy)
import F4Tracker.Quest as Quest
import F4Tracker.Menu as Menu
import F4Tracker.Icons as Icons
import F4Tracker.Models as Models exposing (Status(..), saveQuest)


-- quests =
--     [ { id = 1, name = "War Never Changes", status = NotStarted }
--     , { id = 2, name = "Out of Time", status = NotStarted }
--     , { id = 3, name = "Jewel of the Commonwealth", status = NotStarted }
--     , { id = 4, name = "Unlikely Valentine", status = NotStarted }
--     , { id = 5, name = "Getting a Clue", status = InProgress }
--     , { id = 6, name = "Reunions", status = Completed }
--     , { id = 7, name = "Dangerous Minds", status = NotStarted }
--     , { id = 8, name = "The Glowing Sea", status = NotStarted }
--     , { id = 9, name = "Hunter/Hunted", status = NotStarted }
--     , { id = 10, name = "The Molecular Level", status = NotStarted }
--     , { id = 11, name = "Institutionalized", status = NotStarted }
--     ]


type Message x a aa
    = Search String
    | RequestError x
    | RequestSuccess a
    | QuestMessage Quest.Msg
    | QuestSaveError x
    | QuestSaveSuccess aa


type alias Model =
    { searchString : String
    , quests : List Models.Quest
    , questStates : List Quest.Model
    }




init =
    ( { searchString = ""
    , quests = []
    , questStates = []
      }
    , Task.perform RequestError RequestSuccess Models.getQuests
    )


updateQuest quests quest =
  List.map (\q -> if q.id == quest.id then quest else q) quests

updateQuestStatuses quests quest =
  List.map (\q -> if q.quest.id == quest.id then Quest.init quest else q) quests


update action model =
    case action of
        Search s ->
            ( { model | searchString = s }, Cmd.none )
        RequestError _ -> ( model, Cmd.none )
        RequestSuccess quests ->
          ( { model | quests = quests, questStates = List.map Quest.init quests }, Cmd.none )
        QuestMessage msg ->
          case msg of
            Quest.UpdateStatus quest status ->
              let
                updatedQuest = ({ quest | status = status })
              in
                ( { model |
                  quests = updateQuest model.quests updatedQuest
                , questStates = updateQuestStatuses model.questStates updatedQuest
                }, Task.perform QuestSaveError QuestSaveSuccess (saveQuest updatedQuest) )
        QuestSaveError _ ->
          ( model, Cmd.none )
        QuestSaveSuccess _ ->
          ( model, Cmd.none )


filterQuests searchString quests =
    let
        searchStringToLower =
            String.toLower searchString

        hasText quest =
            String.contains searchStringToLower (String.toLower quest.quest.name)
    in
        List.filter hasText quests


view model =
    viewport
        <| padding 10 0 0 0
        <| hcenter
        <| dim "800" "auto"
        <| flowRight
            [ toHtml <| Layout.space 40 25 0 0 <| Menu.view
            , flowDown
                [ padding 0 0 0 22
                    <| borderBottom 1 "#ccc"
                    <| padding 0 0 3 0
                    <| flowRight
                        [ Input.input
                          |> Input.placeholder "Search for a quest"
                          |> Input.value model.searchString
                          |> Input.onInput Search
                          |> Input.color (rgb 85 85 85)
                          |> Input.size 20
                          |> Input.height 30
                          |> Input.toElement
                        , vcenter <| toHtml <| Icons.search 16 (rgb 204 204 204)
                        ]
                , map QuestMessage <| padding 10 0 10 0 <| flowDown (List.map (toHtml << lazy Quest.view) (filterQuests model.searchString model.questStates))
                ]
            ]



-- border color width = fill color << padding width width width width
--
-- threePaddedRectangles = border "#f00" 10 << border "#0f0" 10 << border "#00f" 10
--
-- view model = text "Hello" |> center |> threePaddedRectangles |> threePaddedRectangles |> threePaddedRectangles |> viewport
