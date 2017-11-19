module Data.Category exposing (..)

import Locale.Words as Words


type Category
    = Legitimate
    | FakeNews
    | ClickBait
    | ExtremelyBiased
    | Satire
    | NotNews


fromId : Int -> Category
fromId id =
    case id of
        1 ->
            Legitimate

        2 ->
            FakeNews

        3 ->
            ClickBait

        4 ->
            ExtremelyBiased

        5 ->
            Satire

        6 ->
            NotNews

        _ ->
            Legitimate


toId : Category -> Int
toId category =
    case category of
        Legitimate ->
            1

        FakeNews ->
            2

        ClickBait ->
            3

        ExtremelyBiased ->
            4

        Satire ->
            5

        NotNews ->
            6


toEmoji : Category -> String
toEmoji category =
    case category of
        Legitimate ->
            "✅"

        FakeNews ->
            "💀"

        ClickBait ->
            "🐟"

        ExtremelyBiased ->
            "🙉"

        Satire ->
            "\x1F921"

        NotNews ->
            "🏳️"


toName : Category -> Words.LocaleKey
toName category =
    case category of
        Legitimate ->
            Words.Legitimate

        FakeNews ->
            Words.FakeNews

        ClickBait ->
            Words.ClickBait

        ExtremelyBiased ->
            Words.Biased

        Satire ->
            Words.Satire

        NotNews ->
            Words.NotNews
