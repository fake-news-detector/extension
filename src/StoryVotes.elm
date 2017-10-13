port module StoryVotes exposing (..)

import Data.Category as Category exposing (Category)
import Data.Votes as Votes exposing (PeopleAndRobotVotes, PeopleVote)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (onClickStopPropagation)
import Html exposing (Html)
import Html.Attributes
import List.Extra
import RemoteData exposing (..)
import Stylesheet exposing (..)


type alias Model =
    { url : String, title : String, votes : WebData PeopleAndRobotVotes }


type alias Flags =
    { url : String, title : String }


type Msg
    = OpenFlagPopup
    | VotesResponse (WebData PeopleAndRobotVotes)
    | AddVote { categoryId : Int }


port openFlagPopup : { url : String, title : String } -> Cmd msg


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
    ( { url = flags.url, title = flags.title, votes = NotAsked }
    , Votes.getVotes flags.url flags.title
        |> RemoteData.sendRequest
        |> Cmd.map VotesResponse
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    addVote AddVote


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenFlagPopup ->
            ( model, openFlagPopup { url = model.url, title = model.title } )

        VotesResponse response ->
            ( { model | votes = response }, Cmd.none )

        AddVote { categoryId } ->
            let
                category =
                    Category.fromId categoryId

                isCategory voteCount =
                    voteCount.category == category

                peopleVotes =
                    case model.votes of
                        Success votes ->
                            if List.Extra.find isCategory votes.people == Nothing then
                                { category = category, count = 1 } :: votes.people
                            else
                                List.Extra.updateIf isCategory
                                    (\voteCount -> { voteCount | count = voteCount.count + 1 })
                                    votes.people

                        _ ->
                            [ { category = category, count = 1 } ]

                updatedVotes =
                    model.votes
                        |> RemoteData.map (\votes -> { votes | people = peopleVotes })
                        |> RemoteData.withDefault { robot = [], people = peopleVotes }
            in
            ( { model | votes = Success updatedVotes }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style
            [ ( "position", "absolute" )
            , ( "right", "0" )
            , ( "z-index", "1" )
            ]
        ]
        [ Element.layout stylesheet (flagButtonAndVotes model)
        ]


flagButtonAndVotes : Model -> Element Classes variation Msg
flagButtonAndVotes model =
    column General
        [ spacing 5, padding 5, minWidth (px 130) ]
        [ button Button [ padding 4, onClickStopPropagation OpenFlagPopup ] (text "🏴 Sinalizar")
        , case model.votes of
            Success votes ->
                viewVotes votes

            Failure _ ->
                el VoteCountItem [ padding 6 ] (text "erro ao carregar")

            _ ->
                empty
        ]


viewVotes : PeopleAndRobotVotes -> Element Classes variation Msg
viewVotes votes =
    column NoStyle
        [ spacing 5 ]
        [ case Votes.bestRobotGuess votes.robot of
            Just ( category, chance ) ->
                row VoteCountItem
                    [ padding 6, spacing 5, height (px 26) ]
                    [ el VoteEmoji [ moveUp 5 ] (text "\x1F916")
                    , text (toString chance ++ "%")
                    , text (Category.toName category)
                    ]

            Nothing ->
                empty
        , column NoStyle [ spacing 5 ] (List.map viewPeopleVotes votes.people)
        ]


viewRobotVotes : PeopleVote -> Element Classes variation Msg
viewRobotVotes voteCount =
    row VoteCountItem
        [ padding 6, spacing 5, height (px 26) ]
        [ el VoteEmoji [ moveUp 4 ] (text (Category.toEmoji voteCount.category))
        , text (toString voteCount.count)
        , text (Category.toName voteCount.category)
        ]


viewPeopleVotes : PeopleVote -> Element Classes variation Msg
viewPeopleVotes voteCount =
    row VoteCountItem
        [ padding 6, spacing 5, height (px 26) ]
        [ el VoteEmoji [ moveUp 4 ] (text (Category.toEmoji voteCount.category))
        , text (toString voteCount.count)
        , text (Category.toName voteCount.category)
        ]
