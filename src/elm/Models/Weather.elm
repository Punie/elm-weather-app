module Models.Weather exposing (Weather, weatherDecoder)

import Json.Decode exposing (Decoder, float, string)
import Json.Decode.Pipeline exposing (decode, requiredAt)


type alias Weather =
    { summary : String
    , temperature : Float
    }


weatherDecoder : Decoder Weather
weatherDecoder =
    decode Weather
        |> requiredAt [ "hourly", "summary" ] string
        |> requiredAt [ "currently", "temperature" ] float
