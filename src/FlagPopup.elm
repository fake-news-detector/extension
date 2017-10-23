port module FlagPopup exposing (..)

import Data.Category as Category exposing (Category(..))
import Data.Votes as Votes
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import Helpers exposing (humanizeError, onClickStopPropagation)
import Html exposing (Html)
import Html.Attributes
import Keyboard
import Locale.Languages exposing (Language)
import Locale.Locale as Locale exposing (translate)
import Locale.Words as Words exposing (LocaleKey)
import RemoteData exposing (..)
import Stylesheet exposing (..)


type alias Model =
    { isOpen : Bool
    , uuid : String
    , isExtensionPopup : Bool
    , url : String
    , title : String
    , selectedCategory : Maybe Category
    , submitResponse : WebData ()
    , language : Language
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { isOpen = False
      , uuid = flags.uuid
      , isExtensionPopup = flags.isExtensionPopup
      , url = ""
      , title = ""
      , selectedCategory = Nothing
      , submitResponse = NotAsked
      , language = Locale.fromCodeArray flags.languages
      }
    , Cmd.none
    )


port broadcastVote : { url : String, categoryId : Int } -> Cmd msg


port openFlagPopup : ({ url : String, title : String } -> msg) -> Sub msg


type Msg
    = OpenPopup { url : String, title : String }
    | ClosePopup
    | SelectCategory Category
    | SubmitFlag
    | SubmitResponse (WebData ())
    | KeyboardDown Keyboard.KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenPopup { url, title } ->
            ( { model | isOpen = True, url = url, title = title }, Cmd.none )

        ClosePopup ->
            init
                { uuid = model.uuid
                , isExtensionPopup = model.isExtensionPopup
                , languages = Locale.toCodeArray model.language
                }

        SelectCategory category ->
            ( { model | selectedCategory = Just category }, Cmd.none )

        SubmitFlag ->
            case model.selectedCategory of
                Just selectedCategory ->
                    ( { model | submitResponse = RemoteData.Loading }
                    , Votes.postVote model.uuid model.url model.title selectedCategory
                        |> RemoteData.sendRequest
                        |> Cmd.map SubmitResponse
                    )

                Nothing ->
                    ( model, Cmd.none )

        SubmitResponse response ->
            if isSuccess response then
                ( Tuple.first (update ClosePopup model)
                , broadcastVote
                    { url = model.url
                    , categoryId =
                        model.selectedCategory
                            |> Maybe.map Category.toId
                            |> Maybe.withDefault 0
                    }
                )
            else
                ( { model | submitResponse = response }, Cmd.none )

        KeyboardDown code ->
            -- 27 is the escape keycode
            if code == 27 then
                update ClosePopup model
            else
                ( model, Cmd.none )


type alias Flags =
    { uuid : String, isExtensionPopup : Bool, languages : List String }


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ openFlagPopup OpenPopup
        , Keyboard.downs KeyboardDown
        ]


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "float", "right" ) ]
        ]
        [ Element.layout stylesheet (popup model)
        ]


popup : Model -> Element Classes variation Msg
popup model =
    when model.isOpen
        (if model.isExtensionPopup then
            modalContents model
         else
            row NoStyle
                []
                [ screen <|
                    el Overlay
                        [ width (percent 100)
                        , height (percent 100)
                        , onClick ClosePopup
                        ]
                        empty
                , modal NoStyle
                    [ center
                    , verticalCenter
                    ]
                    (modalContents model)
                ]
        )


modalContents : Model -> Element Classes variation Msg
modalContents model =
    let
        translate =
            Locale.translate model.language
    in
    el Popup
        [ padding 20, width (px 450) ]
        (column General
            [ spacing 15 ]
            [ h1 Title [] (text <| translate Words.ReportContent)
            , paragraph NoStyle [] [ text <| translate Words.ReportQuestion ]
            , flagForm model
            ]
            |> onRight [ button CloseButton [ onClick ClosePopup, padding 8, moveLeft 8, moveUp 20 ] (text "x") ]
        )


flagForm : Model -> Element Classes variation Msg
flagForm model =
    let
        translate =
            Locale.translate model.language
    in
    node "form" <|
        column NoStyle
            [ spacing 15 ]
            [ Input.radio NoStyle
                [ spacing 15
                ]
                { onChange = SelectCategory
                , selected = model.selectedCategory
                , label = Input.labelAbove empty
                , options = []
                , choices =
                    [ flagChoice Legitimate
                        (translate Words.Legitimate)
                        (translate Words.LegitimateDescription)
                    , flagChoice FakeNews
                        (translate Words.FakeNews)
                        (translate Words.FakeNewsDescription)
                    , flagChoice ClickBait
                        (translate Words.ClickBait)
                        (translate Words.ClickBaitDescription)
                    , flagChoice ExtremelyBiased
                        (translate Words.ExtremelyBiased)
                        (translate Words.ExtremelyBiasedDescription)
                    , flagChoice Satire
                        (translate Words.Satire)
                        (translate Words.SatireDescription)
                    , flagChoice NotNews
                        (translate Words.NotNews)
                        (translate Words.NotNewsDescription)
                    ]
                }
            , case model.submitResponse of
                Failure err ->
                    paragraph ErrorMessage [ padding 6 ] [ text (humanizeError model.language err) ]

                _ ->
                    empty
            , row NoStyle
                [ width fill, spread, verticalCenter ]
                [ italic ("link: " ++ model.url)
                , button BlueButton
                    [ padding 5, onClickStopPropagation SubmitFlag ]
                    (if isLoading model.submitResponse then
                        text <| translate Words.Loading
                     else
                        text <| translate Words.ReportButton
                    )
                ]
            ]


flagChoice : Category -> String -> String -> Input.Choice Category Classes variation msg
flagChoice category title description =
    Input.choice category <|
        Element.column NoStyle
            [ spacing 12 ]
            [ bold title
            , paragraph NoStyle [] [ text <| description ]
            ]
