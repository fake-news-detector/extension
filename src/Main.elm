module Main exposing (..)

import Color exposing (..)
import Element exposing (..)
import Element.Attributes exposing (..)
import Html exposing (Html)
import Html.Attributes
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color


type MyStyles
    = NoStyle
    | Button
    | VoteCount


stylesheet : Style.StyleSheet MyStyles variation
stylesheet =
    styleSheet
        [ style Button
            [ Color.text (rgb 75 79 86)
            , Color.background (rgb 246 247 249)
            , Border.all 1
            , Color.border (rgb 75 79 86)
            ]
        , style VoteCount
            [ Color.text white
            , Color.background (rgba 0 0 0 0.8)
            , Border.rounded 6
            ]
        ]


main : Html msg
main =
    Html.div
        [ Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "right", "0" )
            , ( "z-index", "1" )
            ]
        ]
        [ Element.layout stylesheet view
        ]


view : Element MyStyles variation msg
view =
    column NoStyle
        [ spacing 5, padding 5 ]
        [ button Button [ padding 4 ] (text "🏴 Sinalizar")
        , el VoteCount [ padding 6 ] (text "\x1F916 60% click bait")
        ]
