*** SETTINGS ***
Library     OperatingSystem
Library     ./lua_listener_PYTHON_wrapper.py
Library     String

*** Test Cases ***
Open home window and check if temperature and scale is at default value
    [Tags]  RobotTest
    [Template]    The value of ${key} Should Be ${value}
    temperature    68°
    scale    Fahrenheit

*** Keywords ***
The value of ${key} Should Be ${value}
    the value of ${key} must equal ${value}