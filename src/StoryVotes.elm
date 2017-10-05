port module StoryVotes exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (onClickStopPropagation)
import Html exposing (Html)
import Html.Attributes
import Stylesheet exposing (..)


type alias Model =
    { url : String }


type alias Flags =
    { url : String }


type Msg
    = OpenFlagPopup


port openFlagPopup : { url : String } -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { url = flags.url }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFlagPopup ->
            ( model, openFlagPopup { url = model.url } )


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
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
        [ button Button [ padding 4, onClickStopPropagation OpenFlagPopup ] (text "🏴 Sinalizar")
        , el VoteCount [ padding 6 ] (text "\x1F916 60% click bait")
        ]
