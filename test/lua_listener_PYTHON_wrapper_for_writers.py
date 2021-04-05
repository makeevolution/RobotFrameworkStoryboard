import subprocess
import json
import pprint
import re
import threading
from robot.api.deco import keyword

def listener_for_test():
    result = subprocess.run(['sblua','-l','lua_listener_aldo','-e','listener()'],capture_output=True)
    print(result)
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

    with open('window_{}_data_edited.txt'.format(data["mapargs.context_screen"]),'w') as outfile:
        json.dump(data,outfile, indent=4)
        return

