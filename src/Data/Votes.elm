module Data.Votes exposing (..)

import Data.Category as Category exposing (..)
import Http exposing (encodeUri)
import Json.Decode exposing (Decoder, float, int, list, nullable, oneOf)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode
import List.Extra


type alias PeopleVote =
    { category : Category, count : Int }


type alias RobotVote =
    { category : Category, chance : Float }


type alias VerifiedVote =
    { category : Category }


type alias ContentVotes =
    { robot : List RobotVote
    , people : List PeopleVote
    }


type alias VotesResponse =
    { domain : Maybe VerifiedVote
    , content : ContentVotes
    }


type alias OldVotesResponse =
    { verified : Maybe VerifiedVote, robot : List RobotVote, people : List PeopleVote }


type YesNoIdk
    = Yes
    | No
    | DontKnow


type alias NewVote =
    { uuid : String
    , url : String
    , title : String
    , category : Category
    , clickbaitTitle : YesNoIdk
    }


encodeYesNoIdk : YesNoIdk -> Json.Encode.Value
encodeYesNoIdk val =
    case val of
        Yes ->
            Json.Encode.bool True

        No ->
            Json.Encode.bool False

        DontKnow ->
            Json.Encode.null


decodeVotesResponse : Decoder VotesResponse
decodeVotesResponse =
    let
        decodeCategory =
            required "category_id" (Json.Decode.map Category.fromId int)

        decodeDomainCategory =
            decode VerifiedVote
                |> decodeCategory

        decodeRobotVote =
            decode RobotVote
                |> decodeCategory
                |> required "chance" float

        decodePeopleVote =
            decode PeopleVote
                |> decodeCategory
                |> required "count" int

        decodeContentVotes =
            decode ContentVotes
                |> required "robot" (list decodeRobotVote)
                |> required "people" (list decodePeopleVote)
    in
    oneOf
        [ decode VotesResponse
            |> required "domain" (nullable decodeDomainCategory)
            |> required "content" decodeContentVotes
        , decode OldVotesResponse
            |> required "verified" (nullable decodeDomainCategory)
            |> required "robot" (list decodeRobotVote)
            |> required "people" (list decodePeopleVote)
            |> Json.Decode.map
                (\old ->
                    { domain = old.verified
                    , content = { robot = old.robot, people = old.people }
                    }
                )
        ]


getVotes : String -> String -> Http.Request VotesResponse
getVotes url title =
    Http.get ("https://api.fakenewsdetector.org/votes?url=" ++ encodeUri url ++ "&title=" ++ encodeUri title) decodeVotesResponse


encodeNewVote : NewVote -> Json.Encode.Value
encodeNewVote { uuid, url, title, category, clickbaitTitle } =
    Json.Encode.object
        [ ( "uuid", Json.Encode.string uuid )
        , ( "url", Json.Encode.string url )
        , ( "title", Json.Encode.string title )
        , ( "category_id", Json.Encode.int (Category.toId category) )
        , ( "clickbait_title", encodeYesNoIdk clickbaitTitle )
        ]


postVote : NewVote -> Http.Request ()
postVote newVote =
    Http.post "https://api.fakenewsdetector.org/vote"
        (Http.jsonBody (encodeNewVote newVote))
        (Json.Decode.succeed ())


bestRobotGuess : List RobotVote -> Maybe ( Category, Int )
bestRobotGuess robotVotes =
    List.Extra.maximumBy (\robotVote -> robotVote.chance) robotVotes
        |> Maybe.map (\vote -> ( vote.category, round (vote.chance * 100) ))
