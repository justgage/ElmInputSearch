module View exposing (view)

import Html exposing (..)
import Html.Attributes as Attr
import Html.Events exposing (..)
import Types exposing (..)
import Selectors exposing (employeeFilter)


view : Model -> Html Msg
view model =
    div [ Attr.style [ ( "width", "300px" ), ( "display", "flex" ), ( "flex-direction", "column" ) ] ]
        [ input
            [ Attr.type_ "text"
            , case model.employeeSuggestion of
                Nothing ->
                    Attr.placeholder "Type to Search for Employees Name"

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
