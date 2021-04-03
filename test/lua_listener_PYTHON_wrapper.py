import subprocess
import json
import re
from robot.api.deco import keyword

result = subprocess.run(['sblua','-l','lua_listener_aldo','-e','listener()'],capture_output=True)
mydata = result.stdout.decode("UTF-8")
print(mydata)
regex_for_key = r"\"([^\"]+)\""
regex_for_value = r"\:([^,]+),"
regex_for_no_of_data=r"No of data for Robot Framework testing\":(\d+)}"
data = {}
for i in range(0,int(re.findall(regex_for_no_of_data,mydata)[0])):
    data[re.findall(regex_for_key, mydata)[i]]=re.findall(regex_for_value, mydata)[i]

class lua_listener_PYTHON_wrapper(object):
    """
    @keyword('the key is ${key}')
    def the_key_is(self,key):
        pass
    @keyword('the result should be ${value}')
    def the_result_should_be(self,value):
        print("value")
    """
    @keyword('the value of ${key} must equal ${value}')
    def the_value_of_must_equal(self,KEY,VALUE):
        if (KEY == "temperature"):
            try:
                assert data["thermostat_layer.temp_value.text"] == str(VALUE)
                print("Temperature value OK")
            except AssertionError as e:
                message = "Temperature value is currently at {}, not equal to desired value of {}".format(
                    data["thermostat_layer.temp_value.text"],str(VALUE))
                e.args = (message,)
                raise
        if (KEY == "scale"):
            try:
                assert data["thermostat_layer.temp_scale.text"] == str(VALUE)
                print("Scale value OK")
            except AssertionError as e:
                message = "Scale is currently {}, not equal to desired scale of {}".format(
                    data["thermostat_layer.temp_scale.text"],str(VALUE))
                e.args = (message,)
                raise