module Locale.English exposing (..)

import Locale.Types exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        TLoading ->
            "Loading..."

        TReportContent ->
            "Report Content"
