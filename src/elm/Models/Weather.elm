module Models.Weather exposing (Weather, weatherDecoder)

{-| Tons of useful functions that get imported by default.

@docs Weather
@docs weatherDecoder

-}

import Json.Decode exposing (Decoder, float, string)
import Json.Decode.Pipeline exposing (decode, requiredAt)


{-| -}
type alias Weather =
    { summary : String
    , temperature : Float
    }


{-| -}
weatherDecoder : Decoder Weather
weatherDecoder =
    decode Weather
        |> requiredAt [ "hourly", "summary" ] string
        |> requiredAt [ "currently", "temperature" ] float
