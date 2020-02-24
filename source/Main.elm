module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, a, button, div, img, text)
import Html.Attributes exposing (alt, href, id, src)
import Html.Events exposing (onClick)
import Random
import Random.List


type alias Words =
    List String


chooseWords : Words -> Cmd Msg
chooseWords wordList =
    Random.List.choose wordList
        |> Random.generate WordChosen


type alias Model =
    { value : Int
    , message : String
    , dieFace : Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 0 "Loading..." 1, chooseWords [ "hey", "yo" ] )



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
    | WordChosen ( Maybe String, List String )


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

        WordChosen randomResult ->
            ( { model
                | message =
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
        , div [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
