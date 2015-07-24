function toggleHandbrake( player, vehicle )
	local handbrake = getElementData(player, "handbrake") or isElementFrozen(vehicle) and 1 or 0
	if (handbrake == 0) then
		if isVehicleOnGround(vehicle) or getVehicleType(vehicle) == "Boat" or getElementDimension(vehicle) ~= 0 or getElementModel(vehicle) == 573 then -- 573 = Dune
			exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 1, false)
			setElementFrozen(vehicle, true)
			outputChatBox("Kézifék behúzva!", player, 0, 255, 0)
		else
			outputChatBox("Csak akkor tudod a kéziféket behúzni ha a járműved a földön van.", player, 255, 0, 0)
		end
	else
		exports['anticheat-system']:changeProtectedElementDataEx(vehicle, "handbrake", 0, false)
		setElementFrozen(vehicle, false) 
		outputChatBox("Kézifék kiengedve!", player, 0, 255, 0)
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
	end
end

function cmdHandbrake(sourcePlayer)
	if isPedInVehicle ( sourcePlayer ) and (getElementData(sourcePlayer,"realinvehicle") == 1)then
		local playerVehicle = getPedOccupiedVehicle ( sourcePlayer )
		if (getVehicleOccupant(playerVehicle, 0) == sourcePlayer) then
		    local vx,vy,vz = getElementVelocity(playerVehicle)
			if vx == 0 and vy == 0 and vz == 0 then
			  toggleHandbrake( sourcePlayer, playerVehicle )
            else
              outputChatBox("Persze, meg még a lópikulát, ez nem az a szerver, ahol 120-nál is megállítod magadat kézifékkel...", sourcePlayer, 255, 0, 0)
			end  
		else
			outputChatBox("Sofőrnek kell lenned hogy ezt kezeld...", sourcePlayer, 255, 0, 0)
		end
	else
		outputChatBox("Őőőő, egy kérdés, hogyan húzod be a kéziféket jármű nélkül...", sourcePlayer, 255, 0, 0)
	end
end
addCommandHandler("kézifék", cmdHandbrake)

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler( "vehicle:handbrake", root, function( ) if getVehicleType( source ) == "Trailer" then toggleHandbrake( client, source ) end end )

