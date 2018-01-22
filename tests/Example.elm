module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


suite : Test
suite =
    describe "Test"
        [ test "Yolo" <|
            \_ ->
                Expect.equal True True
        , test "Yala" <|
            \_ ->
                Expect.equalLists [ 1, 2, 3 ] [ 1, 2, 3 ]
        , fuzz (list int) "Yili" <|
            \xs ->
                xs
                    |> List.filter (\n -> n >= 0)
                    |> List.foldr (+) 0
                    |> Expect.atLeast 0
        ]
