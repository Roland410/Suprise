local emitters = { }

function createEmitter(thePlayer, commandName, type)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (type) or (type - 0 > 3) or (type - 0 < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Tűz Tipus]", thePlayer, 255, 194, 14)
			outputChatBox("Tipus 1: Pici tűz", thePlayer, 255, 194, 14)
			outputChatBox("Tipus 2: Közepes tűz", thePlayer, 255, 194, 14)
			outputChatBox("Tipus 3: Nagy tűz", thePlayer, 255, 194, 14)
		else
			local id = #emitters + 1
			local x, y, z = getElementPosition(thePlayer)
			
			emitters[id] = { }
			emitters[id][1] = x
			emitters[id][2] = y
			emitters[id][3] = z - 1
			emitters[id][4] = type
			emitters[id][5] = createObject(848 + type, x, y, z)
			emitters[id][6] = getPlayerName(thePlayer)
			
			setElementAlpha(emitters[id][5], 0)
			setElementDimension(emitters[id][5], getElementDimension(thePlayer))
			setElementInterior(emitters[id][5], getElementInterior(thePlayer))
			outputChatBox("Túz létrehozva ID " .. id .. " és tipusa " .. type .. ".", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("createemitter", createEmitter, false, false)

function nearbyEmitters(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local count = 0
		outputChatBox("közeli tűz: ", thePlayer, 255, 194, 15)
		local px, py, pz = getElementPosition(thePlayer)
		for key, value in ipairs(emitters) do
			local x = emitters[key][1]
			local y = emitters[key][2]
			local z = emitters[key][3]
			local type = emitters[key][4]
			local creator = emitters[key][6]
			
			if ( getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 50) and getElementDimension( thePlayer ) == getElementDimension( value[5] ) then
				count = count + 1
				outputChatBox("tűz ID " .. key .. " tipus " .. type .. " lerakta "..creator..".", thePlayer, 255, 194, 15)
			end
		end
		
		if ( count == 0 ) then
			outputChatBox("Nincs.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("nearbyemitters", nearbyEmitters)

function delEmitter(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("Parancs: /" .. commandName .. " [Tűz ID]", thePlayer, 255, 194, 14)
		else
			if ( emitters[tonumber(id)] == nil ) then
				outputChatBox("Hibás Tűz ID.", thePlayer, 255, 0, 0)
			else
				local obj = emitters[tonumber(id)][5]
				emitters[tonumber(id)] = nil
				destroyElement(obj)
				outputChatBox("Tűz ID " .. id .. " törölve.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("delemitter", delEmitter)

function delEmitters(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		local count = 0
		for k, v in pairs( emitters ) do
			destroyElement( v[5] )
			count = count + 1
		end
		emitters = {}
		outputChatBox("törölve " .. count .. " tűz.", thePlayer, 0, 255, 0)
	end
end
addCommandHandler("delemitters", delEmitters)