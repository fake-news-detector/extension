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
            ""

        FakeNews ->
            "Fake News"

        FakeNewsDescription ->
            ""

        ClickBait ->
            "Click Bait"

        ClickBaitDescription ->
            ""

        ExtremelyBiased ->
            "Extremely Biased"

        ExtremelyBiasedDescription ->
            ""

        Satire ->
            "Satire"

        SatireDescription ->
            ""

        NotNews ->
            "Not News"

        NotNewsDescription ->
            ""
