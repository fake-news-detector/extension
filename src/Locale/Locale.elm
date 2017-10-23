module Locale.Locale exposing (..)

import Locale.English as English
import Locale.Languages exposing (Language(..))
import Locale.Portuguese as Portuguese
import Locale.Words exposing (LocaleKey)


fromCode : String -> Language
fromCode code =
    case code of
        "pt-BR" ->
            Portuguese

        "en" ->
            English

        _ ->
            English


toCode : Language -> String
toCode language =
    case language of
        Portuguese ->
            "pt-BR"

        English ->
            "en"


translate : Language -> LocaleKey -> String
translate language localeValue =
    case language of
        English ->
            English.translate localeValue

        Portuguese ->
            Portuguese.translate localeValue
