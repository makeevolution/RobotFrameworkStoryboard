*** SETTINGS ***
Library     OperatingSystem
Library     ./python.py
Library     String

*** Test Cases ***
Check if string is correct
    [Tags]  RobotTest
    [Template]    The value of ${key} Should Be ${value}
    hey  hey   

*** Keywords ***
The value of ${key} Should Be ${value}
    the value of ${key} must equal ${value}
