*** SETTINGS ***
Library     OperatingSystem
Library     ./lua_listener_PYTHON_wrapper.py
Library     String

*** Test Cases ***
Window 1
    [Template]    The value of ${key} Should Be ${value}
    temperature    68°
    scale    Fahrenheit

*** Keywords ***
The value of ${key} Should Be ${value}
    Then the value of ${key} must equal ${value}