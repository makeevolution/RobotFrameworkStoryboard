import subprocess
from robot.api.deco import keyword
import json
import threading
from lua_listener_PYTHON_wrapper_for_writers import listener_for_test
import time

channel = "Thermostat"

class lua_writer_PYTHON_wrapper(object):
    @keyword('The window home_sc is at start-up default state with default values')
    def retrieve_current_values_at_window(self):
        pass

    @keyword('press plus button once')
    def press_plus_button_once(self):
        with open('window_home_sc_data_default.txt') as f:
            json_data = json.load(f)
        threading.Thread(target=listener_for_test).start()
        time.sleep(1) #Give some time for the thread to start (i.e. time for "listen" channel to be available)
        subprocess.run(['sblua','-l','lua_do_stuff_aldo','-e',
                        "send_press({},{})".format(json_data["thermostat_layer.plus.grd_x"],json_data["thermostat_layer.plus.grd_y"])],
                       capture_output=True)
        time.sleep(1) #Give some time for the "listen" channel to process the data from the action taken in the above subprocess.run code
        return

    @keyword('check if temperature in window ${window} increases by 1 from default')
    def check_temperature_increase_by_1_from_default(self,window):
        try:
            #Check if files exist. If it does we compare the temperature values and confirm the difference is 1
            default_value_data_raw = open('window_{}_data_default.txt'.format(str(window)))
            changed_value_data_raw = open('window_{}_data_edited.txt'.format(str(window)))

            default_value_data = json.load(default_value_data_raw)
            changed_value_data = json.load(changed_value_data_raw)
            try:
                default_value_data["thermostat_layer.temp_value.text"] = default_value_data["thermostat_layer.temp_value.text"][0:len(default_value_data["thermostat_layer.temp_value.text"])-1]
                changed_value_data["thermostat_layer.temp_value.text"] = changed_value_data["thermostat_layer.temp_value.text"][0:len(changed_value_data["thermostat_layer.temp_value.text"])-1]
                assert int(default_value_data["thermostat_layer.temp_value.text"]) + 1 == int(changed_value_data["thermostat_layer.temp_value.text"])
            except AssertionError as e:
                message = "Temperature is not increased by 1"
                e.args = (message,)
                raise
            finally:
                default_value_data_raw.close
                changed_value_data_raw.close
        except IOError:
            message = "Files containing window data for comparison do not exist/Error loading files"
            e.args = (message,)
            raise
        finally:
            default_value_data_raw.close
            changed_value_data_raw.close
            return
