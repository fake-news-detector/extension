module Locale.Spanish exposing (..)

import Locale.Words exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        Loading ->
            "Cargando..."

        FlagContent ->
            "Señalar contenido"

        FlagQuestion ->
            "¿Cuál de las siguientes opciones define mejor este contenido?"

        FlagSubmitButton ->
            "Señalar"

        Legitimate ->
            "Auténtico"

        LegitimateDescription ->
            "Contenido verdadero, no intenta engañar a nadie, de ninguna manera"

        FakeNews ->
            "Fake News"

        FakeNewsDescription ->
            "Noticia falsa, engaña al lector, difunde rumores"

        ClickBait ->
            "Click Bait"

        ClickBaitDescription ->
            "Título no explica la noticia completa de propósito sólo para ganar clics"

        ExtremelyBiased ->
            "Extremadamente Tienencioso"

        ExtremelyBiasedDescription ->
            "Sólo muestra un lado de la historia, interpreta de forma exagerada algunos puntos, sin ponderación con otros"

        Satire ->
            "Sátira"

        SatireDescription ->
            "Contenido intencionalmente falso, con fines humorísticos"

        NotNews ->
            "No es noticia"

        NotNewsDescription ->
            "Meme, contenido personal o cualquier otra cosa no periodística"

        Verified ->
            "(verificado)"

        FlagButton ->
            "🏴 Señalar"

        InvalidUrlError ->
            "Url inválida: "

        LoadingError ->
            "error al cargar"

        TimeoutError ->
            "Timeout: operación tomó demasiado tiempo"

        NetworkError ->
            "Error de red: compruebe su conexión a Internet"
