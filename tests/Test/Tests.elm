module Test.Tests exposing (suite)

import Expect exposing (Expectation)
import Json.Decode exposing (decodeString)
import Data.Coordinates exposing (Coordinates, coordinatesDecoder)
import Data.Weather exposing (Weather, weatherDecoder)
import Test exposing (..)


coordinatesJSON : String
coordinatesJSON =
    """
    {
       "results" : [
          {
             "formatted_address" : "38000 Grenoble, France",
             "geometry" : {
                "location" : {
                   "lat" : 45.18942980000001,
                   "lng" : 5.7165413
                }
             }
          }
       ],
       "status" : "OK"
    }
    """


weatherJSON : String
weatherJSON =
    """
    {
      "hourly": {
        "summary": "Breezy until tomorrow afternoon."
      },
      "currently": {
        "temperature": 18.93
      }
    }
    """


coordinates : Coordinates
coordinates =
    { latitude = 45.18942980000001
    , longitude = 5.7165413
    , formattedAddress = "38000 Grenoble, France"
    }


weather : Weather
weather =
    { summary = "Breezy until tomorrow afternoon."
    , temperature = 18.93
    }


coordinatesTest : Test
coordinatesTest =
    describe "Coordinates"
        [ test "should decode properly" <|
            \_ ->
                decodeString coordinatesDecoder coordinatesJSON
                    |> Expect.equal (Result.Ok coordinates)
        ]


weatherTest : Test
weatherTest =
    describe "Weather"
        [ test "should decode properly" <|
            \_ ->
                decodeString weatherDecoder weatherJSON
                    |> Expect.equal (Result.Ok weather)
        ]


suite : Test
suite =
    describe "Tests"
        [ coordinatesTest
        , weatherTest
        ]
