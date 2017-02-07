module Main exposing (..)

import Keyboard.Key as Key
import Keyboard
import Types exposing (..)
import Update exposing (update)
import View exposing (view)
import Html exposing (program)


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


init : ( Model, Cmd Msg )
init =
    ( { message = "Elm program is ready. Get started!"
      , employeesName = ""
      , employeeSuggestion = Nothing
      , employeesNameFocused = False
      , customerEmailOrPhone = ""
      , customerName = ""
      , employees =
            [ Employee "Alba Ambler" 4
            , Employee "Billye Briski" 5
            , Employee "Kati Keller" 6
            , Employee "Johnette Jacoby" 7
            , Employee "Paulita Pavelka" 8
            , Employee "Melba Marrin" 9
            , Employee "Marcell Manzo" 10
            , Employee "Karan Kane" 10
            , Employee "Gage Peterson" 10
            , Employee "Sergio Scanlon" 10
            , Employee "Douglass Dameron" 10
            , Employee "Gennie Gwin" 10
            , Employee "Shaquita Silliman" 10
            , Employee "Eufemia Eis" 10
            , Employee "Candida Caddy" 10
            , Employee "Trinity Terrell" 10
            , Employee "Michele Malachi" 10
            , Employee "Bennett Blystone" 10
            , Employee "Luise Linz" 10
            , Employee "Deb Dezern" 10
            , Employee "Jeannie Jungers" 10
            , Employee "Elfriede Eveland" 10
            , Employee "Yuette Yeatman" 10
            , Employee "Rea Rooker" 10
            , Employee "Wilfredo Wilmot" 10
            , Employee "Laure Longshore" 10
            , Employee "Francesca Furness" 10
            , Employee "Willow Wigington" 10
            , Employee "Daniela Denner" 10
            , Employee "Margert Mauk" 10
            , Employee "Hyun Helvey" 10
            , Employee "Coreen Catania" 10
            , Employee "Evita Eubank" 10
            , Employee "Kiley Kato" 10
            , Employee "Eliana Erdman" 10
            , Employee "Doretta Depalma" 10
            , Employee "Jon Jordon" 10
            , Employee "Judy Jackman" 10
            , Employee "Velma Veitch" 10
            , Employee "Peg Pryor" 10
            , Employee "Jeffie Johns" 10
            , Employee "Otis Olive" 10
            , Employee "Tambra Twist" 10
            , Employee "Nathalie Navarro" 10
            , Employee "Donovan Dimmick" 10
            , Employee "Jana Jobin" 10
            , Employee "Clarinda Chew" 10
            , Employee "Shirlene Sturman" 10
            , Employee "Candra Couey" 10
            , Employee "Kimber Kovacich" 10
            , Employee "Cassaundra Carson" 10
            , Employee "Dennis" 10
            ]
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


handleKeyPress : Int -> Msg
handleKeyPress keyCode =
    case (Key.fromCode keyCode) of
        Key.Enter ->
            TakeSuggestion

        Key.Down ->
            NextSuggestion

        Key.Up ->
            PreviousSuggestion

        -- Esc
        Key.Unknown 27 ->
            CloseDropDown
            

        _ ->
            NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.employeesNameFocused then
        Keyboard.downs handleKeyPress
    else
        Sub.none
