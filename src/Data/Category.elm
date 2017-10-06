module Data.Category exposing (..)


type Category
    = Legitimate
    | FakeNews
    | ClickBait
    | ExtremelyBiased
    | Satire


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


toName : Category -> String
toName category =
    case category of
        Legitimate ->
            "legítimo"

        FakeNews ->
            "fake news"

        ClickBait ->
            "click bait"

        ExtremelyBiased ->
            "tendencioso"

        Satire ->
            "Sátira"
