module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, a, button, div, img, text)
import Html.Attributes exposing (alt, href, id, src)
import Html.Events exposing (onClick)
import Random
import Random.List


type alias Words =
    List String


wordBank : Words
wordBank =
    [ "hey"
    , "yo"
    , "bro"
    , "thing"
    , "what?"
    , "make it stop"
    ]


chooseWord : Words -> (( Maybe String, List String ) -> Msg) -> Cmd Msg
chooseWord wordList command =
    Random.List.choose wordList
        |> Random.generate command


type alias Model =
    { value : Int
    , message : String
    , otherMessage : String
    , dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 "Loading..." "Just wait." 1, chooseWord wordBank FirstWordChosen )



-- https://dev.to/mickeyvip/writing-a-word-memory-game-in-elm-part-4-spicing-things-up-with-randomness-58ei


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Msg
    = Increment
    | Decrement
    | Roll
    | NewFace Int
    | PickWords
    | FirstWordChosen ( Maybe String, List String )
    | SecondWordChosen ( Maybe String, List String )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | value = model.value + 1 }, Cmd.none )

        Decrement ->
            ( { model | value = model.value - 1 }, Cmd.none )

        Roll ->
            ( model, Random.generate NewFace (Random.int 1 6) )

        NewFace newFace ->
            ( { model | dieFace = newFace }, Cmd.none )

        PickWords ->
            ( model, chooseWord wordBank FirstWordChosen )

        FirstWordChosen randomResult ->
            ( { model
                | message =
                    case Tuple.first randomResult of
                        Nothing ->
                            ""

                        Just word ->
                            word
              }
            , chooseWord (Tuple.second randomResult) SecondWordChosen
            )

        SecondWordChosen randomResult ->
            ( { model
                | otherMessage =
                    case Tuple.first randomResult of
                        Nothing ->
                            ""

                        Just word ->
                            word
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div [ id "capture" ] [ text "Counter" ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ text model.message ]
        , div [] [ text model.otherMessage ]
        , button [ onClick PickWords ] [ text "Pick Words" ]
        , div [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
