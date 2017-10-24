module Locale.English exposing (..)

import Locale.Words exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        Loading ->
            "Loading..."

        ReportContent ->
            "Report Content"

        ReportQuestion ->
            "Which of the following options best defines this content?"

        ReportButton ->
            "Report"

        Legitimate ->
            "Legitimate"

        LegitimateDescription ->
            "Honest content, does not try to fool anyone"

        FakeNews ->
            "Fake News"

        FakeNewsDescription ->
            "Tries to fool the reader and spreads rumors"

        ClickBait ->
            "Click Bait"

        ClickBaitDescription ->
            "Fancy title, does not explain anything about the news just to get more clicks"

        ExtremelyBiased ->
            "Extremely Biased"

        ExtremelyBiasedDescription ->
            "Shows only one side of the story, some points of the news would be exaggerated"

        Satire ->
            "Satire"

        SatireDescription ->
            "Fake content on purpose, just to make humor"

        NotNews ->
            "Not News"

        NotNewsDescription ->
            "Meme, personal content or anything that is not news"

        Verified ->
            "(verified)"

        FlagReportButton ->
            "🏴 Report"

        InvalidUrlError ->
            "Invalid Url: "

        LoadingError ->
            "loading error"

        TimeoutError ->
            "Timeout: the operation took too long to execute"

        NetworkError ->
            "Network error: check your internet connection"
