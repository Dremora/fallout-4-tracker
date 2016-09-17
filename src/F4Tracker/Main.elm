module F4Tracker.Main exposing (..)

import String
import Color exposing (rgb)
import Task
import Html.App exposing (map)

import Html exposing (div, input)
import Html.Events exposing (onInput)
import Html.Attributes exposing (style, placeholder, value)

import Styles.Flexbox exposing (row, vcenter, column, padding, margin, hcenter, width, height)
import Styles.Input as Input
import Styles.Text exposing (color, size)

import F4Tracker.Quest as Quest
import F4Tracker.Menu as Menu
import F4Tracker.Icons as Icons
import F4Tracker.Models as Models exposing (Status(..), saveQuest)


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


search searchString =
  div [ row, vcenter, margin 0 0 0 22, padding 0 0 3 0, style [
    ("border-bottom", "1px solid #ccc")
  ] ] [
    input [
      placeholder "Search for a quest", onInput Search, value searchString
    , Input.input, height 30, size 20, color (rgb 85 85 85)
    ] [ ]
  , Icons.search 16 (rgb 204 204 204)
  ]


view model =
  let
    filteredQuests = filterQuests model.searchString model.questStates
  in
    div [ row, padding 10 0 0 0, hcenter ] [
      div [ row, width 800 ] [
        div [ row, padding 40 25 0 0 ] [ Menu.view ]
      , div [ column ] [
          div [ row ] [ search model.searchString ]
        , div [ column, padding 10 0 10 0 ] (List.map (map QuestMessage << Quest.view) filteredQuests)
        ]
      ]
    ]