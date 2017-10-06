port module FlagPopup exposing (..)

import Category exposing (Category(..))
import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Events exposing (..)
import Element.Input as Input
import Helpers exposing (onClickStopPropagation)
import Html exposing (Html)
import Http
import Json.Decode
import Json.Encode
import RemoteData exposing (..)
import Stylesheet exposing (..)


type alias Model =
    { isOpen : Bool
    , url : String
    , selectedCategory : Maybe Category
    , submitResponse : WebData ()
    }


init : ( Model, Cmd Msg )
init =
    ( { isOpen = False
      , url = ""
      , selectedCategory = Nothing
      , submitResponse = NotAsked
      }
    , Cmd.none
    )


port broadcastVote : { url : String, categoryId : Int } -> Cmd msg


type Msg
    = OpenPopup { url : String }
    | ClosePopup
    | SelectCategory Category
    | SubmitFlag
    | SubmitResponse (WebData ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenPopup { url } ->
            ( { model | isOpen = True, url = url }, Cmd.none )

        ClosePopup ->
            init

        SelectCategory category ->
            ( { model | selectedCategory = Just category }, Cmd.none )

        SubmitFlag ->
            case model.selectedCategory of
                Just selectedCategory ->
                    ( { model | submitResponse = Loading }
                    , Http.post "https://fake-news-detector-api.herokuapp.com/vote"
                        (Http.jsonBody <|
                            Json.Encode.object
                                [ ( "uuid", Json.Encode.string "123" )
                                , ( "url", Json.Encode.string model.url )
                                , ( "title", Json.Encode.string "foo" )
                                , ( "category_id", Json.Encode.int (Category.toId selectedCategory) )
                                ]
                        )
                        (Json.Decode.succeed ())
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
    openFlagPopup OpenPopup


view : Model -> Html Msg
view model =
    Element.layout stylesheet (popup model)


popup : Model -> Element Classes variation Msg
popup model =
    when model.isOpen
        (screen <|
            el Overlay
                [ width (percent 100), height (percent 100) ]
                (modal Popup
                    [ center, verticalCenter, padding 20, width (px 450) ]
                    (column NoStyle
                        [ spacing 15 ]
                        [ h1 Title [] (text "Sinalizar conteúdo")
                        , paragraph NoStyle [] [ text "Qual das opções abaixo define melhor este conteúdo?" ]
                        , flagForm model
                        ]
                        |> onRight [ button CloseButton [ onClick ClosePopup, padding 8, moveLeft 8, moveUp 20 ] (text "x") ]
                    )
                )
        )


flagForm : Model -> Element Classes variation Msg
flagForm model =
    node "form" <|
        column NoStyle
            []
            [ Input.radio NoStyle
                [ spacing 15
                ]
                { onChange = SelectCategory
                , selected = model.selectedCategory
                , label = Input.labelAbove empty
                , options = []
                , choices =
                    [ flagChoice Legitimate
                        "Legítimo"
                        "Conteúdo honesto, não tenta enganar ninguém, de forma alguma"
                    , flagChoice FakeNews
                        "Fake News"
                        "Notícia falsa, engana o leitor, espalha boatos"
                    , flagChoice ClickBait
                        "Click Bait"
                        "Título apelativo, não explica a notícia completa de propósito apenas para ganhar cliques"
                    , flagChoice ExtremelyBiased
                        "Extremamente Tendencioso"
                        "Mostra apenas um lado da história, interpreta de forma exagerada alguns pontos, sem ponderamento com outros"
                    , flagChoice Satire
                        "Sátira"
                        "Conteúdo propositalmente falso, para fins humorísticos"
                    ]
                }
            , case model.submitResponse of
                Failure err ->
                    paragraph NoStyle [] [ text (toString err) ]

                _ ->
                    empty
            , row NoStyle
                [ width fill, paddingTop 20, spread, verticalCenter ]
                [ italic ("link: " ++ model.url)
                , button BlueButton
                    [ padding 5, onClickStopPropagation SubmitFlag ]
                    (if isLoading model.submitResponse then
                        text "Carregando..."
                     else
                        text "Sinalizar"
                    )
                ]
            ]


flagChoice : Category -> String -> String -> Input.Choice Category Classes variation msg
flagChoice category title description =
    Input.choice category <|
        Element.column NoStyle
            [ spacing 12 ]
            [ bold title
            , paragraph NoStyle [] [ text description ]
            ]
