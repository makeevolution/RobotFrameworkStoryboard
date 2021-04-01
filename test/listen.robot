*** SETTINGS ***
Library     OperatingSystem
Library     lua_listener_PYTHON_wrapper.py
Library     String

*** Test Cases ***
Listen to event    [Documentation]     Listen to a particular event from the Storyboard. This event is defined in the Lua function.
                   [Tags]      button
                   ${output}    Listen To Events
                   ${output}    Convert To String   ${output}
                   ${desire}=   Set Variable    buttonpressed
                   Should Contain   ${output}     ${desire}

*** Keywords ***
