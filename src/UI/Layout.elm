module UI.Layout exposing (Element, container, toHtml, fromText, space, spaceBottom
  , spaceTop, spaceLeft, spaceRight, flowDown, flowRight, auto, px, pct, onClick
  , cursor, Cursor(..), start, center, empty, lazy, stretch)

import Html
import Html.Attributes
import Html.Events as Events
import Html.Lazy
import UI.Text as T exposing (Text, leftAligned)
-- import Native.UI.Layout


-- type Thunk =


type Element msg =
  Empty
  | TextElement (Attributes msg) Text
  | Container Size Size Position Position (Attributes msg) (Element msg)
  | ListContainer Flow Size Size (Attributes msg) (List (Element msg))
  -- | Thunk (Lazy.Lazy (Element msg)) (Attributes msg)


type Size =
  Auto
  | Px Int
  | Pct Int


type Flow =
  Bottom | Right

type Position =
  Start | End | Center | Stretch


empty = Empty

center = Center
start = Start
stretch = Start


auto = Auto
px size = Px size
pct size = Pct size

type Cursor = DefaultCursor | Pointer


type alias Attributes a =
  { margin : { top : Maybe Int, right : Maybe Int, bottom : Maybe Int, left : Maybe Int }
  , width : Maybe Size
  , onClick : Maybe a
  , cursor : Maybe Cursor
  }


initAttributes =
  { margin = { top = Nothing, right = Nothing, bottom = Nothing, left = Nothing }
  , width = Nothing
  , onClick = Nothing
  , cursor = Nothing
  }


modifyAttributes : (Attributes msg -> Attributes msg) -> Element msg -> Element msg
modifyAttributes fn element =
  case element of
    Container width height positionx positiony attributes element ->
      Container width height positionx positiony (fn attributes) element
    TextElement attributes element ->
      TextElement (fn attributes) element
    ListContainer flow width height attributes children ->
      ListContainer flow width height (fn attributes) children
    Empty -> element
    -- Thunk element attrs -> element (fn attributes)

cursor : Cursor -> Element msg -> Element msg
cursor cursor =
  modifyAttributes (\attrs -> { attrs | cursor = Just cursor })


fromText : Text -> Element msg
fromText text =
  TextElement initAttributes text


container : Size -> Size -> Position -> Position -> Element msg -> Element msg
container width height positionx positiony element =
  let
    positionedElement = case positionx of
      -- Stretch ->
      _ -> element
  in
    Container width height positionx positiony initAttributes positionedElement


-- toHtmlWithAttributes : Element -> (List (String, String), Element)
-- toHtmlWithAttributes element attrs =
--   case element of
--     StyledElement key value element ->
--       toHtmlWithAttributes ((key, value) :: attrs) element
--     _ ->
--       (attrs, element)


toHtml : Element msg -> Html.Html msg
toHtml element =
  case element of
    Empty ->
      Html.text ""
    Container width height positionx positiony attrs element ->
      -- case element of
        -- Empty -> Html.div [] []
      Html.div (Html.Attributes.style (containerAttrsToCss width height positionx positiony attrs) :: attrsToHtmlAttrs attrs) [ toHtml element ]
    TextElement attrs text ->
      Html.div (Html.Attributes.style (stylesToCss attrs) :: attrsToHtmlAttrs attrs) [ T.toHtml text ]
    ListContainer flow width height attrs children ->
      Html.div (Html.Attributes.style (listContainerAttrsToCss flow width height attrs) :: attrsToHtmlAttrs attrs) (List.map toHtml children)
    -- Thunk element attrs ->


spaceTop : Int -> Element msg -> Element msg
spaceTop px =
  modifyMargin (\margin -> { margin | top = Just px })


spaceBottom : Int -> Element msg -> Element msg
spaceBottom px =
  modifyMargin (\margin -> { margin | bottom = Just px })


spaceLeft : Int -> Element msg -> Element msg
spaceLeft px =
  modifyMargin (\margin -> { margin | left = Just px })


spaceRight : Int -> Element msg -> Element msg
spaceRight px =
  modifyMargin (\margin -> { margin | right = Just px })


space : Int -> Int -> Int -> Int -> Element msg -> Element msg
space top right bottom left =
  spaceTop top << spaceRight right << spaceBottom bottom << spaceLeft left


modifyMargin fn =
  modifyAttributes (\attrs -> { attrs | margin = fn attrs.margin })


flowDown : Size -> Size -> List (Element msg) -> Element msg
flowDown width height children =
  ListContainer Bottom width height initAttributes children


flowRight : Size -> Size -> List (Element msg) -> Element msg
flowRight width height children =
  ListContainer Right width height initAttributes children


onClick : msg -> Element msg -> Element msg
onClick msg =
  modifyAttributes (\styles -> { styles | onClick = Just msg })


cursorToString : Cursor -> String
cursorToString cursor =
  case cursor of
    DefaultCursor -> "default"
    Pointer -> "pointer"


stylesToCss styles =
  List.filterMap identity [
    Just ( "display", "flex" )
  , Just ( "position", "relative" )
  -- , Just ( "border-width", "0" )
  -- , Just ( "border-style", "solid" )
  , Just ( "box-sizing", "border-box" )
  , Just ( "flex-shrink", "0" )
  , Just ( "flex-grow", "0" )
  -- , Just ( "flex-direction", "column" )
  , Maybe.map (\top -> ("margin-top", toString top ++ "px")) styles.margin.top
  , Maybe.map (\right -> ("margin-right", toString right ++ "px")) styles.margin.right
  , Maybe.map (\bottom -> ("margin-bottom", toString bottom ++ "px")) styles.margin.bottom
  , Maybe.map (\left -> ("margin-left", toString left ++ "px")) styles.margin.left
  , Maybe.map (\cursor -> ("cursor", cursorToString cursor)) styles.cursor
  ]


sizeToCss : Size -> String
sizeToCss size =
  case size of
    Auto -> "auto"
    Px size -> toString size ++ "px"
    Pct size -> toString size ++ "%"



attrsToHtmlAttrs properties =
  List.filterMap identity
  [ Maybe.map Events.onClick properties.onClick
  ]


listContainerAttrsToCss flow width height styles =
  stylesToCss styles
  `List.append`
  [ ( "flex-direction", case flow of
      Bottom -> "column"
      Right -> "row"
    )
  , ( "width", sizeToCss width )
  , ( "height", sizeToCss height )
  ]


containerAttrsToCss width height positionx positiony styles =
  stylesToCss styles
  `List.append`
  List.filterMap identity
  [ Just ( "width", sizeToCss width )
  , Just ( "height", sizeToCss height )
  , case positionx of
      Start -> Just ("justify-content", "flex-start")
      Center -> Just ("justify-content", "center")
      End -> Just ("justify-content", "flex-end")
      Stretch -> Nothing
  , Just <| case positiony of
      Start -> ("align-items", "flex-start")
      Center -> ("align-items", "center")
      End -> ("align-items", "flex-end")
      Stretch -> ("align-items", "stretch")
  ]


lazy : (a -> Element msg) -> a -> Element msg
lazy view model =
  view model
  -- Thunk Lazy.lazy (\() -> view model) initAttributes


    -- Html.div
    --     [ boxStyles
    --     , style
    --         [ ( "padding-top", (toString top) ++ "px" )
    --         , ( "padding-right", (toString right) ++ "px" )
    --         , ( "padding-bottom", (toString bottom) ++ "px" )
    --         , ( "padding-left", (toString left) ++ "px" )
    --         ]
    --     ]
    --     [ contents ]


-- flowRight : List Element -> Element
-- -- all elements use preferred intrinsic width and maximum common height
-- -- it should not be possible to set height or position of the children
-- flowBottom
-- -- all elements use maximum width and preferred intrinsic height
-- -- it should not be possible to set width or position of the children
--
--
--
-- fixed width height =
--
-- stretch -- either flex: 1 or t/b/l/r 0/0/0/0
--
--
-- wrap -- wraps another box, as tightly as possible
--
--

-- rect width height x y
-- center = rect auto auto center center
--
-- rect
--
-- hCenter
--
-- vCenter
--
--
-- decorate : Element -> Element
-- position : <Position> -> Element -> PositionedElement
--
-- wrap = container auto auto stretch
