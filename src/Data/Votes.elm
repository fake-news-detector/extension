module Data.Votes exposing (..)

import Data.Category as Category exposing (..)
import Http exposing (encodeUri)
import Json.Decode
import Json.Encode
import List.Extra


type alias PeopleVote =
    { category : Category, count : Int }


type alias RobotVote =
    { category : Category, chance : Float }


type alias PeopleAndRobotVotes =
    { robot : List RobotVote, people : List PeopleVote }


decodePeopleAndRobotVotes : Json.Decode.Decoder PeopleAndRobotVotes
decodePeopleAndRobotVotes =
    Json.Decode.map2 PeopleAndRobotVotes
        (Json.Decode.field "robot" decodeRobotVotes)
        (Json.Decode.field "people" decodePeopleVotes)


decodeRobotVotes : Json.Decode.Decoder (List RobotVote)
decodeRobotVotes =
    Json.Decode.list
        (Json.Decode.map2 RobotVote
            (Json.Decode.field "category_id" Json.Decode.int
                |> Json.Decode.map Category.fromId
            )
            (Json.Decode.field "chance" Json.Decode.float)
        )


decodePeopleVotes : Json.Decode.Decoder (List PeopleVote)
decodePeopleVotes =
    Json.Decode.list
        (Json.Decode.map2 PeopleVote
            (Json.Decode.field "category_id" Json.Decode.int
                |> Json.Decode.map Category.fromId
            )
            (Json.Decode.field "count" Json.Decode.int)
        )


getVotes : String -> String -> Http.Request PeopleAndRobotVotes
getVotes url title =
    Http.get ("https://fake-news-detector-api.herokuapp.com/votes?url=" ++ encodeUri url ++ "&title=" ++ encodeUri title) decodePeopleAndRobotVotes


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
    Http.post "https://fake-news-detector-api.herokuapp.com/vote"
        (Http.jsonBody (encodeNewVote uuid url title category))
        (Json.Decode.succeed ())


bestRobotGuess : List RobotVote -> Maybe ( Category, Int )
bestRobotGuess robotVotes =
    List.Extra.maximumBy (\robotVote -> robotVote.chance) robotVotes
        |> Maybe.map (\vote -> ( vote.category, round (vote.chance * 100) ))
