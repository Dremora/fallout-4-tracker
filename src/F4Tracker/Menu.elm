module F4Tracker.Menu exposing (view)

import UI.Text as Text exposing (text, size, bold, weight)
import UI.Layout exposing (auto, flowDown, fromText, space, spaceRight, spaceBottom)


data =
    [ { label = "Quests"
      , categories =
            [ { label = "Main" }
            , { label = "Side" }
            ]
      }
    , { label = "Items"
      , categories =
            [ { label = "Main" }
            , { label = "Side" }
            ]
      }
    ]


view =
    flowDown auto auto (List.map section data)


section model =
    spaceBottom 10
        <| flowDown auto auto
        <| (spaceBottom 2 <| fromText (size 18 (bold (text model.label))))
        :: List.map category model.categories


category model =
     space 4 0 0 10 <| fromText <| size 16 <| weight 200 <| text model.label
