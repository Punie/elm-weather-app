module Data.Coordinates exposing (Coordinates, coordinatesDecoder)

{-| Tons of useful functions that get imported by default.

@docs Coordinates
@docs coordinatesDecoder

-}

import Json.Decode exposing (Decoder, at, field, float, index, string)
import Json.Decode.Pipeline exposing (custom, decode)


{-| -}
type alias Coordinates =
    { latitude : Float
    , longitude : Float
    , formattedAddress : String
    }


{-| -}
coordinatesDecoder : Decoder Coordinates
coordinatesDecoder =
    decode Coordinates
        |> custom (field "results" (index 0 (at [ "geometry", "location", "lat" ] float)))
        |> custom (field "results" (index 0 (at [ "geometry", "location", "lng" ] float)))
        |> custom (field "results" (index 0 (field "formatted_address" string)))
