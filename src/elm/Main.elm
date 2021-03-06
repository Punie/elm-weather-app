module Main exposing (main)

import Bootstrap.Alert as Alert
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Geolocation as Geo exposing (Location)
import Html
import Http
import Data.Coordinates exposing (Coordinates, coordinatesDecoder)
import Data.Weather exposing (Weather, weatherDecoder)
import RemoteData exposing (RemoteData(..), WebData)
import Task


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    emptyModel ! []



-- MODEL


type alias Model =
    { input : String
    , coordinates : WebData Coordinates
    , weather : WebData Weather
    }


emptyModel : Model
emptyModel =
    { input = ""
    , coordinates = NotAsked
    , weather = NotAsked
    }



-- UPDATE


type Msg
    = Input String
    | Submit
    | RequestCurrentLocation
    | CurrentLocationResponse (Result Geo.Error Location)
    | CoordResponse (WebData Coordinates)
    | WeatherResponse (WebData Weather)


getCoordinates : String -> Cmd Msg
getCoordinates address =
    Http.get ("http://maps.googleapis.com/maps/api/geocode/json?address=" ++ address) coordinatesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map CoordResponse


getWeather : Coordinates -> Cmd Msg
getWeather { latitude, longitude } =
    Http.get ("https://api.darksky.net/forecast/ef6fa285d158d903b73b56d355195759/" ++ toString latitude ++ "," ++ toString longitude ++ "?units=si") weatherDecoder
        |> RemoteData.sendRequest
        |> Cmd.map WeatherResponse


getCurrentLocation : Cmd Msg
getCurrentLocation =
    Task.attempt CurrentLocationResponse Geo.now


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input str ->
            { model | input = str } ! []

        Submit ->
            { model | coordinates = Loading } ! [ getCoordinates model.input ]

        RequestCurrentLocation ->
            { model | input = "" } ! [ getCurrentLocation ]

        CurrentLocationResponse response ->
            case response of
                Err _ ->
                    model ! []

                Ok location ->
                    let
                        coords =
                            toString location.latitude ++ "," ++ toString location.longitude
                    in
                        { model | coordinates = NotAsked } ! [ getCoordinates coords ]

        CoordResponse ((Success coords) as response) ->
            { model
                | coordinates = response
                , weather = Loading
            }
                ! [ getWeather coords ]

        CoordResponse response ->
            { model | coordinates = response } ! []

        WeatherResponse response ->
            { model | weather = response } ! []



-- VIEW


view : Model -> Html.Html Msg
view model =
    Grid.container []
        [ Grid.row []
            [ Grid.col [ Col.md6, Col.offsetMd3 ]
                [ Form.formInline []
                    [ Input.text [ Input.placeholder "Address", Input.onInput Input ]
                    , Button.button
                        [ Button.primary
                        , Button.onClick Submit
                        , Button.disabled <| model.input == ""
                        ]
                        [ Html.text "Submit" ]
                    , Button.button
                        [ Button.primary
                        , Button.onClick RequestCurrentLocation
                        ]
                        [ Html.text "My Location" ]
                    ]
                , Html.div [] [ viewCoords model.coordinates ]
                , Html.div [] [ viewWeather model.weather ]
                ]
            ]
        ]


viewCoords : WebData Coordinates -> Html.Html Msg
viewCoords coordinatesWebData =
    case coordinatesWebData of
        NotAsked ->
            Html.text ""

        Loading ->
            Alert.info [ Html.text "Loading..." ]

        Failure err ->
            Alert.danger
                [ Alert.h3 [] [ Html.text "Error" ]
                , Html.p [] [ Html.text <| toString err ]
                ]

        Success { latitude, longitude, formattedAddress } ->
            Alert.success
                [ Alert.h4 [] [ Html.text formattedAddress ]
                , Html.p [] [ Html.text ("(" ++ toString latitude ++ ", " ++ toString longitude ++ ")") ]
                ]


viewWeather : WebData Weather -> Html.Html Msg
viewWeather weatherWebData =
    case weatherWebData of
        NotAsked ->
            Html.text ""

        Loading ->
            Alert.warning [ Html.text "Loading..." ]

        Failure err ->
            Alert.danger
                [ Alert.h3 [] [ Html.text "Error" ]
                , Html.p [] [ Html.text <| toString err ]
                ]

        Success { summary, temperature } ->
            Alert.info
                [ Alert.h3 [] [ Html.text "Weather" ]
                , Html.p [] [ Html.text summary ]
                , Html.p [] [ Html.text <| "Temperature: " ++ toString (round temperature) ++ "°C" ]
                ]
