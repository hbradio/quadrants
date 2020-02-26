module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, a, button, div, img, text)
import Html.Attributes exposing (alt, href, id, src)
import Html.Events exposing (onClick)
import Random
import Random.List



-- https://dev.to/mickeyvip/writing-a-word-memory-game-in-elm-part-4-spicing-things-up-with-randomness-58ei


type alias WordPair =
    ( String, String )


type alias WordPairs =
    List WordPair


type alias ChosenWordHandler =
    ( Maybe WordPair, List WordPair ) -> Msg


wordBank : WordPairs
wordBank =
    [ ( "sweet", "savory" )
    , ( "conservative", "liberal" )
    , ( "modest", "gaudy" )
    , ( "broad", "narrow" )
    , ( "sweet", "sassy" )
    ]


chooseWord : WordPairs -> ChosenWordHandler -> Cmd Msg
chooseWord wordList command =
    Random.List.choose wordList
        |> Random.generate command


type alias Model =
    { value : Int
    , xAxisPair : WordPair
    , yAxisPair : WordPair
    , dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 ( "", "" ) ( "", "" ) 1, chooseWord wordBank FirstWordChosen )


main : Program () Model Msg
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
    | FirstWordChosen ( Maybe WordPair, List WordPair )
    | SecondWordChosen ( Maybe WordPair, List WordPair )


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
            let
                selectedWordPair =
                    Tuple.first randomResult

                remainingWordPairs =
                    Tuple.second randomResult
            in
            ( { model
                | xAxisPair =
                    case selectedWordPair of
                        Nothing ->
                            ( "", "" )

                        Just wordPair ->
                            wordPair
              }
            , chooseWord remainingWordPairs SecondWordChosen
            )

        SecondWordChosen randomResult ->
            let
                selectedWordPair =
                    Tuple.first randomResult
            in
            ( { model
                | yAxisPair =
                    case selectedWordPair of
                        Nothing ->
                            ( "", "" )

                        Just wordPair ->
                            wordPair
              }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div [ id "capture" ] [ text "Counter" ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        , div [] [ text (Tuple.first model.xAxisPair) ]
        , div [] [ text (Tuple.second model.xAxisPair) ]
        , div [] [ text (Tuple.first model.yAxisPair) ]
        , div [] [ text (Tuple.second model.yAxisPair) ]
        , button [ onClick PickWords ] [ text "Pick Words" ]
        , div [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
