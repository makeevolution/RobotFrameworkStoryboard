*** SETTINGS ***
Library     OperatingSystem
library     ./lua_writer_PYTHON_wrapper.py


*** Test Cases ***
Scenario: Increase Temperature Value by 1 from default
    [Tags]  RobotTest
    Given The home window is open with default values
    When I press the plus button once
    Then Temperature should increase by 1 from default

*** Keywords ***
The home window is open with default values
    # Run this file using Pabot, so 2s sleep is to wait for the other thread running listen.robot to start listening to listen channel
    # The listen channel will write to the txt file, and we read the data from it
    Sleep   1s
    # Open application from cmd (not possible currently)
I press the plus button once
    press plus button once
    Sleep   1s
Temperature should increase by 1 from default
    ${window}=   Set Variable   home_sc
    ${type string}=    Evaluate     type($window)
    Log To Console     ${type string}
    check if temperature in window ${window} increases by 1 from default

