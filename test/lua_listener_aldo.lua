channel = "listen"

function listener()
    while(1)
    do
        ev = gre.receive_event(channel)
        if ev ~= nil then
           -- for k,v in pairs(ev.data) do
           --    print(tostring(k).." "..tostring(v))
           --end
           return(print(ev.name))
        end
    end
end

function lol()
    return(print('lil'))
end
