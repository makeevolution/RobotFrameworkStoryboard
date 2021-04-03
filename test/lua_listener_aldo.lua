channel = "listen"

function listener()
    local result = {}
    while(1) do
        ev = gre.receive_event(channel)
        if ev ~= nil then
          no_of_data = 0
          for key, value in pairs(ev["data"]) do
              -- prepare json key-value pairs and save them in separate table
              table.insert(result, string.format("\"%s\":%s", key, tostring(value)))
              no_of_data = no_of_data+1
          end
          table.insert(result, string.format("\"%s\":%s", "No of data for Robot Framework testing", tostring(no_of_data)))
          result = "{" .. table.concat(result, ",") .. "}"
          return(print(result))
          -- get simple json string
        end
    end
end