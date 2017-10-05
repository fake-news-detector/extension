module Stylesheet exposing (..)

import Color exposing (..)
import Style exposing (..)
import Style.Border as Border
import Style.Color as Color


type Classes
    = NoStyle
    | Button
    | VoteCount
    | Overlay


stylesheet : Style.StyleSheet Classes variation
stylesheet =
    styleSheet
        [ style Button
            [ Color.text (rgb 75 79 86)
            , Border.all 1
            , Color.background (rgb 246 247 249)
            , Color.border (rgb 206 208 212)
            , hover
                [ Color.background (rgb 233 235 238)
                , Color.border (rgb 75 79 86)
                ]
            ]
        , style VoteCount
            [ Color.text white
            , Color.background (rgba 0 0 0 0.6)
            , Border.rounded 6
            ]
        , style Overlay
            [ Color.background (rgba 0 0 0 0.2)
            ]
        ]
