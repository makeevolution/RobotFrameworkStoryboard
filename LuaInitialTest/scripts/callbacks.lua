---
-- @module callbacks
--  This class contains functions to underpin the general callbacks funtionality. 
--  It is intended to be an application global utility class
--  

local screen_text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."


-- Callback for 'Press' button to be triggered by gre.press action
function CBHandleMainClickPress(mapargs) 

  local data={}
  data["mainLayer.status_text.text"] = "Activated"
  gre.set_data(data)

end

-- Callback for 'Press' button to be triggered by gre.release and gre.outbound actions
--- @param gre#context mapargs
function CBHandleMainClickRelease(mapargs) 

  local data={}
  data["mainLayer.status_text.text"] = "Deactivated"
  gre.set_data(data)

end

-- Perform any dynamic screen configuration here
function CBHandleSecondScreenInit(mapargs) 

  local data = {}
  data["navLayer.content_text.text"] = screen_text
  gre.set_data(data)

end