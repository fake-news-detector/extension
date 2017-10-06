module Data.Votes exposing (..)

import Data.Category as Category exposing (..)
import Http exposing (encodeUri)
import Json.Decode
import Json.Encode


type alias VoteCount =
    { category : Category, count : Int }


decodeVoteCount : Json.Decode.Decoder (List VoteCount)
decodeVoteCount =
    Json.Decode.list
        (Json.Decode.map2 VoteCount
            (Json.Decode.field "category_id" Json.Decode.int
                |> Json.Decode.map Category.fromId
            )
            (Json.Decode.field "count" Json.Decode.int)
        )


getVotes : String -> Http.Request (List VoteCount)
getVotes url =
    Http.get ("https://fake-news-detector-api.herokuapp.com/votes?url=" ++ encodeUri url) decodeVoteCount


encodeNewVote : String -> Category -> Json.Encode.Value
encodeNewVote url category =
    Json.Encode.object
        [ ( "uuid", Json.Encode.string "123" )
        , ( "url", Json.Encode.string url )
        , ( "title", Json.Encode.string "foo" )
        , ( "category_id", Json.Encode.int (Category.toId category) )
        ]


postVote : String -> Category -> Http.Request ()
postVote url category =
    Http.post "https://fake-news-detector-api.herokuapp.com/vote"
        (Http.jsonBody (encodeNewVote url category))
        (Json.Decode.succeed ())
