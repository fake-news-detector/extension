module FlagPopup exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Html exposing (Html)
import Stylesheet exposing (..)


type alias Model =
    { isOpen : Bool }


model : Model
model =
    { isOpen = False }


type Msg
    = OpenFlagPopup


update : Msg -> Model -> Model
update msg model =
    case msg of
        OpenFlagPopup ->
            { model | isOpen = True }


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


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
                    (text "hello darkness my old frieeeend")
                )
        )
