module Main exposing (..)

import Example
import Test.Runner.Html


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run Example.suite
