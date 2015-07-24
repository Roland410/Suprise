mysql = exports.mysql

function finishDutySkin(x, y, z, rot, dimension, interior, newskin)
	setElementDimension(client, dimension)
	setElementInterior(client, interior)
	setElementPosition(client, x, y, z)
	setPedRotation(client, rot)
	setCameraTarget(client)
	exports['anticheat-system']:changeProtectedElementDataEx(client, "dutyskin", newskin, false)
	exports.mysql:query_free( "UPDATE characters SET dutyskin = " .. newskin .. " WHERE id = " .. getElementData( client, "dbid" ) )
	
	local duty = tonumber(getElementData(client, "duty"))
	local csapat = getPlayerTeam ( client )
	local theTeam = getTeamName(csapat)
	
	local factionType = tonumber(getElementData(csapat, "type"))

	if (duty>0) or (factionType == 0) or (factionType == 1) then -- on duty, let's give them the skin now
		setElementModel(client, newskin)
		exports.mysql:query_free( "UPDATE characters SET skin = " .. newskin .. " WHERE id = " .. getElementData( client, "dbid" ) )
	end
end
addEvent("finishDutySkin", true)
addEventHandler("finishDutySkin", getRootElement(), finishDutySkin)

-- INSECURE
function storeWeapons(weapons)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "dutyguns", weapons, true)
end
addEvent("storeDutyGuns", true)
addEventHandler("storeDutyGuns", getRootElement(), storeWeapons)