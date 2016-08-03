module F4Tracker.Models exposing (Status(..), Quest, getQuests, saveQuest)

import Http exposing (Body, Error, defaultSettings, fromJson, send)
import Json.Decode exposing (..)
import Json.Encode as Encode
import Task exposing (Task)

type Status
    = NotStarted
    | InProgress
    | Completed


type alias Quest =
  { id : Int
  , name : String
  , status : Status
  , category : String
  }


createQuest id name category status =
  { id = id, name = name, category = category, status = status}


statusDecoder : String -> Decoder Status
statusDecoder status =
  case status of
    "not_started" ->
      succeed NotStarted
    "in_progress" ->
      succeed InProgress
    "completed" ->
      succeed Completed
    _ ->
      fail (status ++ " is not a recognized status for quests")


questDecoder : Decoder Quest
questDecoder =
  object4 createQuest
    ("id" := int)
    ("name" := string)
    ("category" := string)
    ("status" := string `andThen` statusDecoder)


statusEncoder : Status -> Encode.Value
statusEncoder status =
  case status of
    NotStarted -> Encode.string "not_started"
    InProgress -> Encode.string "in_progress"
    Completed -> Encode.string "completed"


questEncoder : Quest -> Encode.Value
questEncoder quest =
  Encode.object [
    ("quest", Encode.object [
      ("id", Encode.int quest.id)
    , ("name", Encode.string quest.name)
    , ("category", Encode.string quest.category)
    , ("status", statusEncoder quest.status)
    ])
  ]


questListDecoder : Decoder (List Quest)
questListDecoder =
  "data" := (list questDecoder)


getQuests =
  Http.get questListDecoder "http://localhost:4000/api/quests"


saveQuest quest =
  put (succeed ()) ("http://localhost:4000/api/quests/" ++ (toString quest.id)) (Http.string <| Encode.encode 0 <| questEncoder quest)


put : Decoder value -> String -> Body -> Task Error value
put decoder url body =
  let request =
        { verb = "PUT"
        , headers =
          [ ("Content-Type", "application/json")
          ]
        , url = url
        , body = body
        }
  in
      fromJson decoder (send defaultSettings request)
