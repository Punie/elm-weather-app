module Main exposing (main)

import Test.Tests
import Test.Runner.Html


main : Test.Runner.Html.TestProgram
main =
    Test.Runner.Html.run Test.Tests.suite
