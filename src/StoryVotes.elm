port module StoryVotes exposing (..)

import Data.Category as Category exposing (Category)
import Data.Votes as Votes exposing (VoteCount)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (onClickStopPropagation)
import Html exposing (Html)
import Html.Attributes
import Http exposing (encodeUri)
import List.Extra
import Stylesheet exposing (..)


type alias Model =
    { url : String, votes : List VoteCount }


type alias Flags =
    { url : String }


type Msg
    = OpenFlagPopup
    | VotesResponse (Result Http.Error (List VoteCount))
    | AddVote { categoryId : Int }


port openFlagPopup : { url : String } -> Cmd msg


port addVote : ({ categoryId : Int } -> msg) -> Sub msg


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { url = flags.url, votes = [] }
    , Votes.getVotes flags.url
        |> Http.send VotesResponse
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    addVote AddVote


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFlagPopup ->
            ( model, openFlagPopup { url = model.url } )

        VotesResponse response ->
            case response of
                Ok votes ->
                    ( { model | votes = votes }, Cmd.none )

                Err err ->
                    ( model, Cmd.none )

        AddVote { categoryId } ->
            let
                category =
                    Category.fromId categoryId

                isCategory voteCount =
                    voteCount.category == category

                votes =
                    if List.Extra.find isCategory model.votes == Nothing then
                        { category = category, count = 1 } :: model.votes
                    else
                        List.Extra.updateIf isCategory
                            (\voteCount -> { voteCount | count = voteCount.count + 1 })
                            model.votes
            in
            ( { model | votes = votes }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "right", "0" )
            , ( "z-index", "1" )
            ]
        ]
        [ Element.layout stylesheet (viewVotes model)
        ]


viewVotes : Model -> Element Classes variation Msg
viewVotes model =
    column NoStyle
        [ spacing 5, padding 5 ]
        [ button Button [ padding 4, onClickStopPropagation OpenFlagPopup ] (text "🏴 Sinalizar")
        , row VoteCountItem
            [ padding 6, spacing 5, height (px 26) ]
            [ el VoteEmoji [ moveUp 5 ] (text "\x1F916")
            , text "60%"
            , text "click bait"
            ]
        , column NoStyle [ spacing 5 ] (List.map viewVote model.votes)
        ]


viewVote : VoteCount -> Element Classes variation Msg
viewVote voteCount =
    row VoteCountItem
        [ padding 6, spacing 5, height (px 26) ]
        [ el VoteEmoji [ moveUp 5 ] (text (Category.toEmoji voteCount.category))
        , text (toString voteCount.count)
        , text (Category.toName voteCount.category)
        ]
