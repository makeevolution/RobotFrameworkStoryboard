import subprocess


filename = "C:\\Users\\aldo-\\storyboard_workspace\\webinar\\event_capture2.txt"
channel = "LuaModulesTest"

def press_middle_button():
    result = subprocess.check_output(['sblua','lua_do_stuff_aldo.lua'])
#    return result
