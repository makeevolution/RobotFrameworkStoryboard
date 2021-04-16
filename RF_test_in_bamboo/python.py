from robot.api.deco import keyword

class python(object): #class name must be the same as python name
    @keyword('the value of ${key} must equal ${value}')
    def check_value(self,key,value):
        try:
            assert key==value
        except Exception as e:
            e.args = e.args + "test fails, {} is not equal to {}".format(key,value)

