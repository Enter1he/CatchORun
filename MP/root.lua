local socket = require"socket.core"
local host = 'localhost'
local port = 12345
local message = "CatchORun"

local address = socket.dns.toip(host)

local A = socket.dns.getaddrinfo(socket.dns.gethostname())
for k,v in pairs(A[2]) do
    print(k,v)
end
print(A)
local Client;

local getIP = function()
    local s = socket.udp()  --creates a UDP object
    s:setpeername( "74.125.115.104", 80 )  --Google website
    local ip, sock = s:getsockname()
    print( "myIP:", ip, sock )
    return ip
end

getIP()

-- Client:setoption('broadcast', true)

local Server = socket.udp()
Server:setsockname('127.0.0.1', port)
print(Server)

Server:settimeout(0)


local MP = NewScene{blend = 0}
local text = Text.newText("press enter to start", 13, "res/Catchofont.ttf")
text.pos = {200, 25}
local layer = Layer.new(MP)
local role = Mob.newMob{
    name = "host";
    char = "";
    state = "waiting";
}
text.value = role.name
local guest = {
    data = "";
    ip = "";
    port = "";
    state = "looking"
}

local rpos = role.pos

function MP.Load()
    print"is host"
    text:Load()
    layer:AddDrawable(text)
end

Controls.AddCommand(B.esc, LE.Close)
local counter = 0
Controls.AddCommand(B.enter,
function()
    if role.name == "host" then
        counter = 0
        role.name = "guest"
        text.value = "guest"
        role.state = "looking"
        if Server then
            Server:close()
            Server = nil    
        end
        
        -- assert(Client:setsockname(host, port))
        if Client then
            Client:close()
        end
        Client = socket.udp()
        assert(Client:setsockname(address, 11111))
        Client:settimeout(0)
        print"Now you're quest"
        rpos[1] = 13
        rpos[2] = 7    
    elseif role.name == "guest" then
        counter = 0
        if Client then
            Client:close()
            Client = nil
        end
        Server:close()
        Server = socket.udp()
        Server:setsockname(host, port)
        Server:settimeout(0)
        role.name = "host"
        text.value = "host"
        role.state = "looking"
        print"Now you're host"
        rpos[1] = 0
        rpos[2] = 0 
    end
    
end)

Controls.AddCommand(B.r, function ()
    print"reset"
    counter = 0
end)

Controls.AddCommand(B.g, function ()
    if role.name == 'host' then
        print(Server:getsockname())
    end
    if role.name == 'quest' then
        print(Client:getpeername())
    end
end)

function MP.Update()
    local str = string.format(tostring(rpos[1]).."-"..tostring(rpos[2]))
    local data, ip, p;
    
    if role.name == "guest" then
        
        data, ip, p = Client:receivefrom()    
        
        
        if data then
            print(data)
        end
        
        if data and data == message then
            
            print(data, ip, p)
            Client:sendto(str, ip, p)
            text.value = data    
        end
    elseif role.name == 'host' then
        -- counter = counter + 1
        -- if counter > 960 then 
        --     return nil
        -- end
        -- data, ip, p = Server:receivefrom()

        local err, msg = Server:setoption( "broadcast", true )  --turn on broadcast
        if not err then
            print(err, msg)
        end
        err, msg = Server:sendto( message, '255.255.255.255', 11111 )
        Server:setoption( "broadcast", false )  --turn off broadcast
        if not err then
            print(err, msg)
        end
        
        if data then
            print(data)
            text.value = data
        end
    end
    
    -- if uClie then
    --     data, msg_or_ip, port_or_nil = uClie:receive()
    --     uClie:send(tostring(rpos[1])..'-'..tostring(rpos[2]))
        
    -- else
    --     data, msg_or_ip, port_or_nil = uServ:receivefrom()
    --     if data then
    --         uServ:sendto(tostring(rpos[1])..'-'..tostring(rpos[2]), msg_or_ip, port_or_nil)
    --         print(data)
    --     end
        
    -- end
    
end


return MP