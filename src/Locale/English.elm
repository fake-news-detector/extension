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
