module F4Tracker.Menu exposing (view)

import Html exposing (div, span, text)
import Styles.Text as Text exposing (size, bold, weight)
import Styles.Flexbox exposing (row, column, padding, hcenter, width)


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
  div [ column ] (List.map section data)


section model =
  div [ column, padding 0 0 10 0 ]
    <| (div [ column, padding 0 0 2 0 ] [
      span [ size 18, bold ] [ text model.label ]
    ])
    :: List.map category model.categories


category model =
  div [ column, padding 4 0 0 10 ] [
    span [ size 16, weight 200 ] [ text model.label ]
  ]
