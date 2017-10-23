module Locale.Portuguese exposing (..)

import Locale.Words exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        Loading ->
            "Caregando..."

        ReportContent ->
            "Sinalizar conteúdo"

        ReportQuestion ->
            "Qual das opções abaixo define melhor este conteúdo?"
