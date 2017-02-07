module Update exposing (update)

import Types exposing (..)
import Selectors exposing (..)


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
                        |> updateDropDown (not (String.isEmpty value))
                    , Cmd.none
                    )

                CostomersPhoneOrEmail ->
                    ( { model | customerEmailOrPhone = value }, Cmd.none )

                CustomersName ->
                    ( { model | customerName = value }, Cmd.none )

        DropDown open ->
            ( model
                |> updateTakeSuggestion
                |> updateDropDown (not (String.isEmpty model.employeesName) && open)
            , Cmd.none
            )

        SuggestEmployee employee ->
            ( { model | employeeSuggestion = employee }, Cmd.none )

        TakeSuggestion ->
            ( updateTakeSuggestion model, Cmd.none )

        NextSuggestion ->
            ( { model | employeeSuggestion = (findNextSuggestion model) }, Cmd.none )

        PreviousSuggestion ->
            ( { model | employeeSuggestion = (findPreviousSuggestion model) }, Cmd.none )


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
