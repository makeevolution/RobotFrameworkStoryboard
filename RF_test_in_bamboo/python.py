from robot.api.deco import keyword

class python(object): #class name must be the same as python name
    @keyword('the value of ${key} must equal ${value}')
    def check_value(self,key,value):
        assert key==value

