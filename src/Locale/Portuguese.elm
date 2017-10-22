module Locale.Portuguese exposing (..)

import Locale.Types exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        TLoading ->
            "Caregando..."

        TReportContent ->
            "Sinalizar conteúdo"
