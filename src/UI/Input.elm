module UI.Input exposing (input, height, onInput, size, toElement, color, value, placeholder)

import Color exposing (Color, toRgb)
import UI.Text as Text
import UI.Shared exposing (colorToCss)
import Html
import Html.Attributes as Attributes
import Html.Events as Events


type Input msg
    = Input
        { value : Maybe String
        , placeholder : Maybe String
        , weight : Maybe Int
        , size : Int
        , line : Maybe Text.Line
        , color : Maybe Color
        , height : Maybe Int
        , placeholderColor : Maybe Color
        , onInput : Maybe (String -> msg)
        }


input =
    Input
        { value = Nothing
        , placeholder = Nothing
        , weight = Nothing
        , size = 16
        , line = Nothing
        , color = Nothing
        , height = Nothing
        , placeholderColor = Nothing
        , onInput = Nothing
        }


height h input =
    case input of
        Input i ->
            Input { i | height = Just h }


weight w input =
    case input of
        Input i ->
            Input { i | weight = Just w }


size s input =
    case input of
        Input i ->
            Input { i | size = s }


color c input =
    case input of
        Input i ->
            Input { i | color = Just c }


value v input =
    case input of
        Input i ->
            Input { i | value = Just v }


placeholder p input =
    case input of
        Input i ->
            Input { i | placeholder = Just p }


onInput e input =
    case input of
        Input i ->
            Input { i | onInput = Just e }


toAttributes input =
    case input of
        Input input ->
            List.filterMap identity
                [ Maybe.map Attributes.placeholder input.placeholder
                , Maybe.map Attributes.value input.value
                , Maybe.map Events.onInput input.onInput
                ]


toCss input =
    case input of
        Input input ->
            List.filterMap identity
                [ Maybe.map (\w -> ( "font-weight", toString w )) input.weight
                , Maybe.map (\l -> ( "text-decoration", Text.lineToCss l )) input.line
                , Maybe.map (\c -> ( "color", colorToCss c )) input.color
                , Just ( "font-size", toString input.size ++ "px" )
                , Just ( "background-color", "transparent" )
                , Just ( "-webkit-appearance", "none" )
                , Just ( "border-width", "0" )
                , Just ( "padding", "0" )
                , Just ( "display", "flex" )
                ]


toElement input =
    Html.input (Attributes.style (toCss input) :: (toAttributes input)) []
