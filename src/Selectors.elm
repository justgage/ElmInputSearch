module Selectors exposing (..)

import List.Extra


findNextSuggestion { employeeSuggestion, employees, employeesName } =
    case employeeSuggestion of
        Nothing ->
            employees
                |> employeeFilter employeesName
                |> List.head

        Just currentSuggestion ->
            let
                nextEmployee =
                    employees
                        |> employeeFilter employeesName
                        |> List.Extra.dropWhile (\e -> currentSuggestion /= e)
                        |> List.Extra.getAt 1
            in
                case nextEmployee of
                    Nothing ->
                        employees
                            |> employeeFilter employeesName
                            |> List.head

                    Just e ->
                        Just e


findPreviousSuggestion { employeeSuggestion, employees, employeesName } =
    case employeeSuggestion of
        Nothing ->
            employees
                |> employeeFilter employeesName
                |> List.Extra.last

        Just currentSuggestion ->
            let
                nextEmployee =
                    employees
                        |> employeeFilter employeesName
                        |> List.Extra.takeWhile (\e -> currentSuggestion /= e)
                        |> List.Extra.last
            in
                case nextEmployee of
                    Nothing ->
                        employees
                            |> employeeFilter employeesName
                            |> List.Extra.last

                    Just e ->
                        Just e


employeeFilter searchString employees =
    let
        lowerSearchString =
            (String.toLower searchString)
    in
        employees
            |> List.filter (\{ name } -> String.contains lowerSearchString (String.toLower name))
            |> List.take 10
