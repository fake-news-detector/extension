port module FlagPopup exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Html exposing (Html)
import Stylesheet exposing (..)


type alias Model =
    { isOpen : Bool, url : String }


init : ( Model, Cmd Msg )
init =
    ( { isOpen = False, url = "" }, Cmd.none )


type Msg
    = OpenFlagPopup { url : String }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFlagPopup { url } ->
            ( { model | isOpen = True, url = url }, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


port openFlagPopup : ({ url : String } -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    openFlagPopup OpenFlagPopup


view : Model -> Html msg
view model =
    Element.layout stylesheet (popup model)


popup : Model -> Element Classes variation msg
popup model =
    when model.isOpen
        (screen <|
            el Overlay
                [ width (percent 100), height (percent 100) ]
                (modal Button
                    [ center, verticalCenter, width (px 300), height (px 300) ]
                    (text ("popup for url" ++ model.url))
                )
        )
