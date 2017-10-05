module Helpers exposing (..)

import Element exposing (..)
import Element.Events exposing (..)
import Json.Decode


onClickStopPropagation : msg -> Element.Attribute variation msg
onClickStopPropagation msg =
    onWithOptions "click"
        { defaultOptions | stopPropagation = True, preventDefault = True }
        (Json.Decode.succeed msg)
