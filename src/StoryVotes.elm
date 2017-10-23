port module StoryVotes exposing (..)

import Data.Category as Category exposing (Category)
import Data.Votes as Votes exposing (PeopleVote, RobotVote, VerifiedVote, VotesResponse)
import Element exposing (..)
import Element.Attributes exposing (..)
import Helpers exposing (onClickStopPropagation)
import Html exposing (Html)
import Html.Attributes
import List.Extra
import Locale.Languages exposing (Language)
import Locale.Locale as Locale exposing (translate)
import Locale.Words as Words exposing (LocaleKey)
import RemoteData exposing (..)
import Stylesheet exposing (..)


type alias Model =
    { url : String, title : String, isExtensionPopup : Bool, votes : WebData VotesResponse, language : Language }


type alias Flags =
    { url : String, title : String, isExtensionPopup : Bool, languages : List String }


type Msg
    = OpenFlagPopup
    | VotesResponse (WebData VotesResponse)
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
    ( { url = flags.url
      , title = flags.title
      , isExtensionPopup = flags.isExtensionPopup
      , votes = NotAsked
      , language = Locale.fromCodeArray flags.languages
      }
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
                        |> RemoteData.withDefault { verified = Nothing, robot = [], people = peopleVotes }
            in
            ( { model | votes = Success updatedVotes }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.div
        [ Html.Attributes.style
            (if model.isExtensionPopup then
                [ ( "float", "right" ) ]
             else
                [ ( "position", "absolute" )
                , ( "right", "0" )
                , ( "z-index", "1" )
                ]
            )
        ]
        [ Element.layout stylesheet (flagButtonAndVotes model)
        ]


flagButtonAndVotes : Model -> Element Classes variation Msg
flagButtonAndVotes model =
    let
        translate =
            Locale.translate model.language

        viewVerifiedVote vote =
            viewVote (Category.toEmoji vote.category) "" vote.category (translate Words.Verified)

        isValidUrl =
            String.startsWith "http"
    in
    if isValidUrl model.url then
        column General
            [ spacing 5, padding 5, minWidth (px 130) ]
            (case model.votes of
                Success votes ->
                    case votes.verified of
                        Just vote ->
                            [ viewVerifiedVote vote ]

                        Nothing ->
                            [ flagButton model, viewVotes votes ]

                Failure _ ->
                    [ flagButton model
                    , el VoteCountItem [ padding 6 ] (text <| translate Words.LoadingError)
                    ]

                _ ->
                    [ flagButton model ]
            )
    else
        el General [ padding 5 ] (text <| translate Words.InvalidUrlError ++ model.url)


flagButton : Model -> Element Classes variation Msg
flagButton model =
    button Button
        [ padding 4, onClickStopPropagation OpenFlagPopup ]
        (text <| Locale.translate model.language Words.FlagReportButton)


viewVotes : VotesResponse -> Element Classes variation Msg
viewVotes votes =
    let
        viewRobotVote ( category, chance ) =
            viewVote "\x1F916" (toString chance ++ "%") category ""

        viewPeopleVote vote =
            viewVote (Category.toEmoji vote.category) (toString vote.count) vote.category ""
    in
    column NoStyle
        [ spacing 5 ]
        [ case Votes.bestRobotGuess votes.robot of
            Just bestGuess ->
                viewRobotVote bestGuess

            Nothing ->
                empty
        , column NoStyle [ spacing 5 ] (List.map viewPeopleVote votes.people)
        ]


viewVote : String -> String -> Category -> String -> Element Classes variation msg
viewVote icon preText category postText =
    row VoteCountItem
        [ padding 6, spacing 5, height (px 26) ]
        [ el VoteEmoji [ moveUp 4 ] (text icon)
        , text preText
        , text (Category.toName category)
        , text postText
        ]
