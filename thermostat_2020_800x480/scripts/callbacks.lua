local temp=20

local glowAnimations = {}

local function CreateGlowAnimation(colour)
  
  local glow = gre.animation_create(30,0)
  local step={}
  
  step["rate"] = "linear"
  step["duration"] = 250
  step["from"] = 0
  step["to"] = 255
  step["key"] = "thermostat_layer.glow_control." .. colour .. "_alpha"
  
  gre.animation_add_step(glow,step)
  
  step["rate"] = "linear"
  step["duration"] = 250
  step["offset"] = 250
  step["from"] = 255
  step["to"] = 0
  step["key"] = "thermostat_layer.glow_control." .. colour .. "_alpha"
  
  gre.animation_add_step(glow,step)

  return glow
end


local function AnimateGlow(colour)
  local animation = glowAnimations[colour]
  if animation== nil then
    animation = CreateGlowAnimation(colour)
  end
  
  gre.animation_trigger(animation)
end
--- @param gre#context mapargs
function CBIncTemp(mapargs) 

  -- Limit temperature to 30 degrees
  if( temp < 30 ) then
    temp=temp+1
    
    -- Update Stroryboard data manager which will trigger a screen update for any controls bound to 
    gre.set_value("thermostat_layer.temperature.text", temp.."º")
    gre.set_value("weather_layer.tempOutValue.text", temp.."º")
  end
    
  AnimateGlow("red") 

end

--- @param gre#context mapargs
function CBDecTemp(mapargs) 

  local data = {}
  
  -- Limit temperature to 30 degrees
  if( temp > 16 ) then
    temp=temp-1

    -- Update Stroryboard data manager which will trigger a screen update for any controls bound to 
    data["thermostat_layer.temperature.text"] = string.format("%dº", temp)
    data["weather_layer.tempOutValue.text"] = string.format("%dº", temp)
  end 
  gre.set_data(data)
  
  AnimateGlow("blue") 
    
end

