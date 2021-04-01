
local function PrintControlPosition(obj)
  if(obj:get_type() == gredom.CONTROL) then
    print(string.format("%s,%d,%d", obj:get_name(), obj:get_x(), obj:get_y()))
  else
    local kids = obj:get_children()
    for i=1,#kids do
      PrintControlPosition(kids[i])
    end
  end 
  
end 

function PrintControlPositions()
  local app = gredom.get_application()
  
  local kids = app:get_children();
  for i=1,#kids do
    PrintControlPosition(kids[i])
  end
end

PrintControlPositions()