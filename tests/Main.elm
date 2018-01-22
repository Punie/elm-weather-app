module Main exposing (..)

import Test.Example
import Test.Runner.Html


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run Test.Example.suite
