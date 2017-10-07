module Helpers exposing (..)

import Element exposing (..)
import Element.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode


onClickStopPropagation : msg -> Element.Attribute variation msg
onClickStopPropagation msg =
    onWithOptions "click"
        { defaultOptions | stopPropagation = True, preventDefault = True }
        (Json.Decode.succeed msg)


humanizeError : Http.Error -> String
humanizeError error =
    case error of
        BadStatus data ->
            data.body

        Timeout ->
            "Timeout: operação demorou tempo demais"

        NetworkError ->
            "Erro de rede: verifique sua conexão à internet"

        BadPayload _ data ->
            data.body

        BadUrl error ->
            error
