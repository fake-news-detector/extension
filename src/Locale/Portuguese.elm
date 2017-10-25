module Locale.Portuguese exposing (..)

import Locale.Words exposing (LocaleKey(..))


translate : LocaleKey -> String
translate localeValue =
    case localeValue of
        Loading ->
            "Carregando..."

        ReportContent ->
            "Sinalizar conteúdo"

        ReportQuestion ->
            "Qual das opções abaixo define melhor este conteúdo?"

        ReportButton ->
            "Sinalizar"

        Legitimate ->
            "Legítimo"

        LegitimateDescription ->
            "Conteúdo honesto, não tenta enganar ninguém, de forma alguma"

        FakeNews ->
            "Fake News"

        FakeNewsDescription ->
            "Notícia falsa, engana o leitor, espalha boatos"

        ClickBait ->
            "Click Bait"

        ClickBaitDescription ->
            "Título apelativo, não explica a notícia completa de propósito apenas para ganhar cliques"

        ExtremelyBiased ->
            "Extremamente Tendencioso"

        ExtremelyBiasedDescription ->
            "Mostra apenas um lado da história, interpreta de forma exagerada alguns pontos, sem ponderamento com outros"

        Satire ->
            "Sátira"

        SatireDescription ->
            "Conteúdo propositalmente falso, para fins humorísticos"

        NotNews ->
            "Não é notícia"

        NotNewsDescription ->
            "Meme, conteúdo pessoal ou qualquer outra coisa não jornalística"

        Verified ->
            "(verificado)"

        FlagReportButton ->
            "🏴 Sinalizar"

        InvalidUrlError ->
            "Url inválida: "

        LoadingError ->
            "erro ao carregar"

        TimeoutError ->
            "Timeout: operação demorou tempo demais"

        NetworkError ->
            "Erro de rede: verifique sua conexão à internet"
