import subprocess

def listen_to_events():
    return subprocess.check_output(['sblua','-l','lua_listener_aldo','-e','listener()'])
