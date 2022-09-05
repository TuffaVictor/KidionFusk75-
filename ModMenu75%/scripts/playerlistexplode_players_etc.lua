local globalValue = 0
 
-- Function definitions
     
 
local function Text(text)
    	menu.add_action(text, function() end)
    end
     
    local function sqrt(i)
    	return i^0.5
    end
     
    local function DistanceToSqr(vec1, vec2)
    	return ((vec2.x - vec1.x)^2) + ((vec2.y - vec1.y)^2) + ((vec2.z - vec1.z)^2)
    end
     
    local function Distance(vec1, vec2)
    	return sqrt(DistanceToSqr(vec1, vec2))
    end
     
    local function floor(num)
    	return num//1
    end
     
    -- Player / Ped functions
     
    local function IsPlayer(ped)
    	if ped == nil or ped:get_pedtype() >= 4 then
    		return false
    	end
    	return true
    end
     
    local function IsNPC(ped)
    	if ped == nil or ped:get_pedtype() < 4 then
    		return false
    	end
    	return true
    end
     
    local function IsModder(ply)
    	if not IsPlayer(ply) then return false end
    	
    	if ply:get_max_health() < 100 then return true end
    	if ply:is_in_vehicle() and ply:get_godmode() then return true end
    	if ply:get_run_speed() > 1.0 or ply:get_swim_speed() > 1.0 then return true end
     
    	return false
    end
     
    local function GetPlayerCount()
    	return player.get_number_of_players()
    end
     
    -- Action functions
     
    local function TeleportToPlayer(ply)
    	if not ply or ply == nil then return end 
     
    	local pos = ply:get_position()
     
    	if not localplayer:is_in_vehicle() then
    		localplayer:set_position(pos)
    	else
    		localplayer:get_current_vehicle():set_position(pos)
    	end
    end
     
    local function TeleportVehiclesToPlayer(ply)
    	if not ply or ply == nil then return end 
     
    	local pos = ply:get_position()
    	local currentvehicle = nil 
     
    	if localplayer:is_in_vehicle() then
    		currentvehicle = localplayer:get_current_vehicle()
    	end
     
    	for veh in replayinterface.get_vehicles() do
    		if not currentvehicle or currentvehicle ~= veh then
    			veh:set_position(pos)
    		end
    	end
    end
     
    local function TeleportClosestVehicleToPlayer(ply)
    	if not ply or ply == nil then return end 
     
    	local pos = ply:get_position()
    	local veh = localplayer:get_nearest_vehicle()
    	if not veh then return end
     
    	veh:set_position(pos)
    end
     
    local function TeleportPedsToPlayer(ply)
    	if not ply or ply == nil then return end 
     
    	local pos = ply:get_position()
    	for ped in replayinterface.get_peds() do
    		if IsNPC(ped) then
    			ped:set_position(pos)
    		end
    	end
    end
     
    local function ExplodePlayer(ply)
    	if not ply or ply == nil then return end 
     
    	local pos = ply:get_position()
    	local currentvehicle = nil 
     
    	if localplayer:is_in_vehicle() then
    		currentvehicle = localplayer:get_current_vehicle()
    	end
     
    	for veh in replayinterface.get_vehicles() do
    		if not currentvehicle or currentvehicle ~= veh then
    			veh:set_rotation(vector3(0,0,180))
    			veh:set_health(-1)
    			veh:set_position(pos)
    		end
    	end
    end
     
    -- Player option 
    local selectedplayer = -1
     
    local function add_player_option(ply_id, ply, ply_name)
    	local text = ""
     
    	-- Player Name
    	if ply == localplayer then
    		text = text.."YOU"
    	else
    		text = text..ply_name
    	end
 
        --text = text.."|=>"
 
        if IsModder(ply) then
            text = text.."|| MOD"
        end
     
    	-- Is In GodMode, if not then Player Health & Armor
            if ply:get_godmode() then
                text = text.."|| GOD"
            else
                text = text.."||"..string.format("%4.0f",(ply:get_health()/ply:get_max_health())*100).."% /"..string.format("%2.0f",ply:get_armour()*2).."%"
            end
     
    	-- Is In Vehicle
        if ply:is_in_vehicle() then
            text = text.." | 🚗 "
        else 
            text = text.." | 🚶 "
        end
     
    	-- Player Wanted Level
        local WantedLevel = ply:get_wanted_level()
        if WantedLevel > 0 then
            text = text.."| "..ply:get_wanted_level().."✰"
        end
 
    	local d = ply_id
     
    	menu.add_toggle(text, function()
    		if selectedplayer == d then
    			return true
    		else
    			return false
    		end
    	end, function(val)
    		selectedplayer = d
    	end)
    end
 
    Text("--Options--")
    menu.add_action("Teleport To Player", function() TeleportToPlayer(player.get_player_ped(selectedplayer)) end)
    menu.add_action("Teleport Closest Vehicle To Player", function() TeleportClosestVehicleToPlayer(player.get_player_ped(selectedplayer)) end)
    menu.add_action("Teleport Vehicles To Player", function() TeleportVehiclesToPlayer(player.get_player_ped(selectedplayer)) end)
    menu.add_action("Teleport Peds To Player", function() TeleportPedsToPlayer(player.get_player_ped(selectedplayer)) end)
    menu.add_action("Explode Player", function() ExplodePlayer(player.get_player_ped(selectedplayer)) end)
    local enabled = false
 
    menu.add_int_range("Times to spam teleport", 1, 0, 999999, function()
        return globalValue
     end, function(value)
        globalValue = value
        return value
     end)
 
    menu.add_toggle("Spam Teleport To Player", function()
        if globalValue == 0 then enabled = false end
        return enabled
    end, function()
        enabled = not enabled
        local ply = player.get_player_ped(selectedplayer)
        if not ply or ply == nil then return end
        local i = 0
 
    	
        if enabled then
            if globalValue > 0 then
                repeat i = i + 1
                    sleep(0.25) --you can change this
                    local pos = ply:get_position()
    	            if not localplayer:is_in_vehicle() then
    		            localplayer:set_position(pos)
    	            else
    		            localplayer:get_current_vehicle():set_position(pos)
    	            end
                until i == globalValue
                i = 0
                globalValue = 0
                enabled = false
            end
        end
 
    end)
    Text("---End---")
    Text("")     
 
    -- Building Player List
     
    Text("---Current Session Player List, "..GetPlayerCount().." Players---")
     
    for i = 0, 31 do
    	local ply = player.get_player_ped(i)
    	if ply then 
    		add_player_option(i, ply, player.get_player_name(i))
    	end
    end
     
     
    Text("---End---")
     
    -- Info Panel
     
    Text("")
    Text("---Checks---")
    menu.add_toggle("Is Selected Player Valid", function()
    	if selectedplayer == -1 then return false end
    	if not player.get_player_ped(selectedplayer) then return false end
    	return true 
    end, function() end)
     
    menu.add_float_range("Distance To Selected Player", 1, 0, 0, function()
    	if selectedplayer == -1 then return 0 end
     
    	local ply = player.get_player_ped(selectedplayer)
     
    	if not IsPlayer(ply) then return 0 end
     
    	return floor(Distance(ply:get_position(), localplayer:get_position()))
    end, function() end)
    
    menu.add_float_range("Player Health", 1, 0, 0, function()
    	if selectedplayer == -1 then return 0 end
     
    	local ply = player.get_player_ped(selectedplayer)
     
    	if not IsPlayer(ply) then return 0 end
     
    	return ply:get_health()
    end, function() end)
 
    menu.add_toggle("Is in vehicle?", function()
        if selectedplayer == -1 then return 0 end
    	local ply = player.get_player_ped(selectedplayer)
    	if not IsPlayer(ply) then return 0 end
 
        if ply:is_in_vehicle() then
    	    return true
        else
            return false
        end
    end, function() end)
 
    menu.add_float_range("Vehicle Health Max. 1000hp", 1, 0, 0, function()
    	if selectedplayer == -1 then return 0 end
     
    	local ply = player.get_player_ped(selectedplayer)
     
    	if not IsPlayer(ply) then return 0 end
        local vehicle = ply:get_current_vehicle()
 
        if ply:is_in_vehicle() then
    	    return vehicle:get_health()
        else
            return false
        end
 
    end, function() end)
 
    menu.add_toggle("Vehicle God", function()
        if selectedplayer == -1 then return 0 end
    	local ply = player.get_player_ped(selectedplayer)
    	if not IsPlayer(ply) then return 0 end
        local vehicle = ply:get_current_vehicle()
 
        if ply:is_in_vehicle() then
    	    if vehicle:get_godmode() == true then return true else return false end
        else
            return false
        end
    end, function() end)
Text("---End---")