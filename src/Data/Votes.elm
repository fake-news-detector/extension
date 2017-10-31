module Data.Votes exposing (..)

import Data.Category as Category exposing (..)
import Http exposing (encodeUri)
import Json.Decode exposing (Decoder, float, int, list, nullable)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode
import List.Extra


type alias PeopleVote =
    { category : Category, count : Int }


type alias RobotVote =
    { category : Category, chance : Float }


type alias VerifiedVote =
    { category : Category }


type alias VotesResponse =
    { verified : Maybe VerifiedVote, robot : List RobotVote, people : List PeopleVote }


decodeVotesResponse : Decoder VotesResponse
decodeVotesResponse =
    let
        decodeCategory =
            required "category_id" (Json.Decode.map Category.fromId int)

        decodeVerifiedVote =
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
    in
    decode VotesResponse
        |> required "verified" (nullable decodeVerifiedVote)
        |> required "robot" (list decodeRobotVote)
        |> required "people" (list decodePeopleVote)


getVotes : String -> String -> Http.Request VotesResponse
getVotes url title =
    Http.get ("https://api.fakenewsdetector.org/votes?url=" ++ encodeUri url ++ "&title=" ++ encodeUri title) decodeVotesResponse


encodeNewVote : String -> String -> String -> Category -> Json.Encode.Value
encodeNewVote uuid url title category =
    Json.Encode.object
        [ ( "uuid", Json.Encode.string uuid )
        , ( "url", Json.Encode.string url )
        , ( "title", Json.Encode.string title )
        , ( "category_id", Json.Encode.int (Category.toId category) )
        ]


postVote : String -> String -> String -> Category -> Http.Request ()
postVote uuid url title category =
    Http.post "https://api.fakenewsdetector.org/vote"
        (Http.jsonBody (encodeNewVote uuid url title category))
        (Json.Decode.succeed ())


bestRobotGuess : List RobotVote -> Maybe ( Category, Int )
bestRobotGuess robotVotes =
    List.Extra.maximumBy (\robotVote -> robotVote.chance) robotVotes
        |> Maybe.map (\vote -> ( vote.category, round (vote.chance * 100) ))
