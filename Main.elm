module Main exposing (..)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (..)
import Keyboard.Key as Key
import Keyboard


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- TYPES


type alias Model =
    { message : String
    , employeesName : String
    , employeesNameFocused : Bool
    , employeeSuggestion : Maybe Employee
    , customerEmailOrPhone : String
    , customerName : String
    , employees : List Employee
    }


type alias Employee =
    { name : String
    , id : Int
    }


type Form
    = EmployeesName
    | CostomersPhoneOrEmail
    | CustomersName


type Msg
    = NoOp
    | UpdateForm Form String
    | DropDown Bool
    | SuggestEmployee (Maybe Employee)
    | TakeSuggestion



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



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateForm form value ->
            case form of
                EmployeesName ->
                    ( model
                        |> updateSearchBox value
                        |> updateDropDown
                            (let
                                numberOfSuggestions =
                                    model.employees
                                        |> employeeFilter value
                                        |> List.length

                                suggestedName =
                                    case model.employeeSuggestion of
                                        Just e ->
                                            e.name

                                        Nothing ->
                                            ""

                                exactMatch =
                                    model.employeesName == suggestedName
                             in
                                numberOfSuggestions > 1 && exactMatch
                            )
                    , Cmd.none
                    )

                CostomersPhoneOrEmail ->
                    ( { model | customerEmailOrPhone = value }, Cmd.none )

                CustomersName ->
                    ( { model | customerName = value }, Cmd.none )

        DropDown open ->
            ( model
                |> updateDropDown open
                |> updateTakeSuggestion
            , Cmd.none
            )

        SuggestEmployee employee ->
            ( { model | employeeSuggestion = employee }, Cmd.none )

        TakeSuggestion ->
            ( updateTakeSuggestion model, Cmd.none )


updateSearchBox value model =
    { model
        | employeesName = value
        , employeeSuggestion =
            if value == "" then
                Nothing
            else
                model.employees
                    |> employeeFilter value
                    |> List.head
    }


updateDropDown open model =
    { model | employeesNameFocused = open }


updateTakeSuggestion model =
    case model.employeeSuggestion of
        Just { name } ->
            { model | employeesName = name }

        Nothing ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div [ Attr.style [ ( "width", "300px" ), ( "display", "flex" ), ( "flex-direction", "column" ) ] ]
        [ input
            [ Attr.type_ "text"
            , case model.employeeSuggestion of
                Nothing ->
                    Attr.placeholder "Employee's Name"

                Just employee ->
                    Attr.placeholder employee.name
            , onInput (UpdateForm EmployeesName)
            , Attr.value model.employeesName
            , onFocus (DropDown True)
            , onBlur (DropDown False)
            ]
            []
        , if model.employeesNameFocused then
            div [ dropdownStyle ] [ viewDropdown model ]
          else
            text ""
        , form []
            [ input
                [ Attr.type_ "text"
                , Attr.placeholder "Customers Phone / Email"
                , onInput (UpdateForm CostomersPhoneOrEmail)
                ]
                []
            , input
                [ Attr.type_ "text"
                , Attr.placeholder "Customers Name (example: John Smith)"
                , onInput (UpdateForm CustomersName)
                ]
                []
            , input
                [ Attr.type_ "submit"
                ]
                [ text "Send Review Invite" ]
            ]
        ]


viewDropdown : Model -> Html Msg
viewDropdown model =
    let
        { employeesName, employees } =
            model

        filteredEmployees =
            employeeFilter employeesName employees
    in
        div [ onMouseLeave (SuggestEmployee Nothing), dropdownContentStyle ] (List.map (viewItem model.employeeSuggestion) filteredEmployees)


dropdownStyle =
    Attr.style
        [ ( "position", "relative" )
        , ( "display", "inline-block" )
        ]


dropdownContentStyle =
    Attr.style
        [ ( "position", "absolute" )
        , ( "background-color", "#f9f9f9" )
        , ( "min-width", "160px" )
        , ( "box-shadow", "0px 8px 16px 0px rgba(0,0,0,0.2)" )
        , ( "padding", "12px 16px" )
        , ( "z-index", "1" )
        ]


employeeFilter searchString employees =
    employees
        |> List.filter (\x -> String.contains searchString x.name)
        |> List.take 10


viewItem : Maybe Employee -> Employee -> Html Msg
viewItem suggestedEmployee employee =
    let
        isMe =
            case suggestedEmployee of
                Just suggested ->
                    suggested == employee

                Nothing ->
                    False

        selectedStyle =
            if isMe then
                [ ( "font-weight", "bold" ) ]
            else
                []
    in
        div
            [ onMouseOver (SuggestEmployee <| Just employee)
            , Attr.style selectedStyle
            ]
            [ text employee.name ]



-- SUBSCRIPTIONS


handleKeyPress keyCode =
    case (Key.fromCode keyCode) of
        Key.Enter ->
            TakeSuggestion

        _ ->
            NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
    Keyboard.downs handleKeyPress
