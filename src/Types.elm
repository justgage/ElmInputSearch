module Types exposing (..)

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
    | NextSuggestion
    | PreviousSuggestion
    | CloseDropDown
