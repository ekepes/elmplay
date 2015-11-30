module SignupForm where

import StartApp
import Effects
import String
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (id, type', for, value, class)

type alias Model = { guess:String, answer:Int, message:String }

type alias Action = { actionType:String, payload:String } 

view actionDispatcher model =
    form
        [ id "guess-form" ]
        [ h1 [] [ text "Guess My Number!" ]
        , label [ for "guess-field" ] [ text "Guess (1-10): " ]
        , input
        [ id "guess-field"
        , type' "text"
        , value model.guess
        , on "input" targetValue (\str -> Signal.message actionDispatcher { actionType = "SET_GUESS", payload = str })
        ]
        []
        , div [ class "validation-error" ] [ text model.message ]
        , div [ class "signup-button", onClick actionDispatcher { actionType = "CHECK_GUESS", payload = "" } ] [ text "Guess!" ]
        ]

checkGuess : Model -> String
checkGuess model =
    if model.guess == "" then
        "Please enter a guess!"
    else
        let num = String.toInt model.guess
        in
            case num of
                Ok value ->
                    if value == model.answer then
                        "You guessed it!"
                    else
                        if value < model.answer then
                            "You are too low."
                        else
                            "You are too high."
                Err error ->
                    "Please enter a number!"

update : Action -> Model -> ( Model, Effects.Effects a )
update action model =
    if action.actionType == "CHECK_GUESS" then
        ( { model | message = checkGuess model }, Effects.none )
    else if action.actionType == "SET_GUESS" then
        ( { model | guess = action.payload }, Effects.none )
    else
        ( model, Effects.none )

initialModel : Model
initialModel = { guess = "", answer = 5, message="" }

app =
    StartApp.start
        { init = ( initialModel, Effects.none )
        , update = update
        , view = view
        , inputs = []
        }

main =
    app.html