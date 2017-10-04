module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


main : Html msg
main =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "right", "0" )
            , ( "z-index", "1" )
            , ( "border", "10px solid red" )
            , ( "color", "white" )
            ]
        ]
        [ text "Bullshit!"
        ]
