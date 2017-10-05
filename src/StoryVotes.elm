module StoryVotes exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Html exposing (Html)
import Html.Attributes
import Stylesheet exposing (..)


type alias Model =
    ()


model : ()
model =
    ()


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "right", "0" )
            , ( "z-index", "1" )
            ]
        ]
        [ Element.layout stylesheet (votes model)
        ]


votes : Model -> Element Classes variation Msg
votes model =
    column NoStyle
        [ spacing 5, padding 5 ]
        [ button Button [ padding 4, onClick NoOp ] (text "🏴 Sinalizar")
        , el VoteCount [ padding 6 ] (text "\x1F916 60% click bait")
        ]
