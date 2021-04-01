*** SETTINGS ***
Library     OperatingSystem
library     lua_writer_PYTHON_wrapper.py

*** Test Cases ***
Press Button    [Documentation]     Simply press the middle
                [Tags]      button
                ${output}=    Press Middle Button
