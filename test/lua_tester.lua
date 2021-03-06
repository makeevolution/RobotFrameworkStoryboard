-- 
-- This module takes apart a playback stream that looks like:
--
-- delta, event, target, <data>
-- 666,gre.motion,,4u1:button 2705413472 4u1:timestamp 1744 2u1:subtype 45056 2s1:x 491 2s1:y 139 2s1:z 0 2s1:id 0 2s1:spare -5838 
--
-- And then injects the contents as message to a channel
--

-- Generic split routine
local function split(inputstr, sep) 
  sep=sep or '%s' 
  local t={} 
  for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do 
    table.insert(t,field) 
    if s=="" then 
      return t 
    end 
  end 
end

-- Convert an event input stream:
-- 4u1:button 2705413472 4u1:timestamp 1744 2u1:subtype 45056 2s1:x 491 2s1:y 139 2s1:z 0 2s1:id 0 2s1:spare -5838
local function make_data_and_format(ln)
  ln = string.gsub(ln, ":", " ")
  local entry = split(ln, " ")
  --print("LN", ln, #entry)
  local fmt = ""
  local data = {}
  for i=1,#entry,3 do
    if(entry[i] == "") then
      break
    end
    fmt = string.format("%s %s %s", fmt, entry[i], entry[i+1]) 
    data[entry[i+1]] = entry[i+2] 
  end

  return data, fmt
 end

-- Parse a playback line
-- 666,gre.motion,,4u1:button 2705413472 4u1:timestamp 1744 2u1:subtype 45056 2s1:x 491 2s1:y 139 2s1:z 0 2s1:id 0 2s1:spare -5838 
local function parse_playback_line(ln)
  local entry = split(ln, ",")
  local ms = entry[1]
  local event = entry[2]
  local target = entry[3]
  local data, fmt = make_data_and_format(entry[4])
  
  return ms, event, data, fmt
end
 
local function msdelay(ms)
  --os.usleep(tonumber(delay) + 1000)
  local endTime = ms + gre.mstime()
  local count = 1
  while(gre.mstime() < endTime) do
    -- Spin
    if(count % 100 == 0) then
      print(".")
    end
  end
end

function playback(filename, channel)
  --print("Loading", filename)
  for line in io.lines(filename) do
    local delay, ev, data, fmt = parse_playback_line(line)
    --print(type(ev))
    msdelay(delay)
    --print("Sending ", delay, ev, fmt)
    print(ev, fmt, data, channel)
    gre.send_event_data(ev, fmt, data, channel)
  end
  --print("Playback complete")
end


function receiveThread()
	print("Receiver waiting...")
	while(true) do
		local ev = gre.receive_event("test_driver")
		if ( ev == nil ) then
			break
		end
		local value = gre.get_data("app:mainLayer.status_text.text")
        print("The width of the control is " .. tostring(value))
		print("TEST DRIVER Received ", ev.name, ev.target, ev.format )
		-- Can add the received events to a queue and process them asynchronously with a try-expect model
		--table.insert("ReceiveEventQueue,ev)
	end
end
--gre.thread_create(receiveThread)
--msdelay(60*1000)


local filename = "C:\\Users\\aldo-\\storyboard_workspace\\webinar\\LuaModulesTest\\event_capture.txt"
local channel = "LuaModulesTest"

function gotoScreen(name, channel)
--[[
>iogen LuaModulesTest screen_name greio.iodata_set 1s0 "firstScreen"
>iogen LuaModulesTest - test_driver_goto_screen
--]]
  local event = {}
  event.name = "greio.iodata_set"
	event.format = "1s0 screen_name"
	event.target = "screen_name"
	event.data = { screen_name = name}
  print("TEST DRIVER set target to screen name '"..name.."' and transition")

	-- first set the target screen as a variable (app:<name>)
  gre.send_event(event, channel)
	
	-- initiate the screen transition
  gre.send_event("test_driver_goto_screen", channel)

end


local value = gre.get_data("app:mainLayer.status_text.text")
--print("The width of the control is " .. tostring(value))
playback( filename, channel )
--gotoScreen( "secondScreen", channel)

