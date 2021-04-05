import subprocess
import json
import pprint
import re
import threading
from robot.api.deco import keyword

result = subprocess.run(['sblua','-l','lua_listener_aldo','-e','listener()'],capture_output=True)
mydata = result.stdout.decode("UTF-8")
regex_for_key = r"\"([^\"]+)\""
regex_for_value = r"\:([^,]+),"
regex_for_no_of_data=r"No of data for Robot Framework testing\":(\d+)}"
data = {}

#Currently, the result variable is a dictionary with key value pairs
#However, the values are not in string form.
#So here we create a new dictionary such that the values are in string form
for i in range(0,int(re.findall(regex_for_no_of_data,mydata)[0])):
    data[re.findall(regex_for_key, mydata)[i]]=re.findall(regex_for_value, mydata)[i]

#Now that the dictionary is in standard form, we can save the data as JSON file
#We will have two files, one file containing the default values of the current window
#and another file with values edited by test cases.
#The following codes create these files.

with open('window_{}_data_default.txt'.format(data["mapargs.context_screen"]),'w') as f:
    json.dump(data,f, indent=4)

class lua_listener_PYTHON_wrapper(object):
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
        return

def listener_for_test():
    result = subprocess.run(['sblua','-l','lua_listener_aldo','-e','listener()'],capture_output=True)
    mydata = result.stdout.decode("UTF-8")
    regex_for_key = r"\"([^\"]+)\""
    regex_for_value = r"\:([^,]+),"
    regex_for_no_of_data=r"No of data for Robot Framework testing\":(\d+)}"
    data = {}

    #Currently, the result variable is a dictionary with key value pairs
    #However, the values are not in string form.
    #So here we create a new dictionary such that the values are in string form
    for i in range(0,int(re.findall(regex_for_no_of_data,mydata)[0])):
        data[re.findall(regex_for_key, mydata)[i]]=re.findall(regex_for_value, mydata)[i]

    #Now that the dictionary is in standard form, we can save the data as JSON file
    #We will have two files, one file containing the default values of the current window
    #and another file with values edited by test cases.
    #The following codes create these files.

    try:
        #Check if file with default value exists. If it does then we write to edited file instead
        f = open('window_{}_data_default.txt'.format(data["mapargs.context_screen"]))
        with open('window_{}_data_edited.txt'.format(data["mapargs.context_screen"]),'w') as outfile:
            json.dump(data,outfile, indent=4)
    except IOError:
        #Default file does not exist; we create the default file
        with open('window_{}_data_default.txt'.format(data["mapargs.context_screen"]),'w') as f:
            json.dump(data,f, indent=4)
    finally:
        #Ensure file handle f is appropriately closed
        f.close
        return