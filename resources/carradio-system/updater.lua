function UpdateRadio(veh)
    local occupants = getVehicleOccupants(veh)
    local seats = getVehicleMaxPassengers(veh)
    for seat = 0, seats do
		local occupant = occupants[seat]
		if occupant and getElementType(occupant) == "player" then 
			local playerid  = getPlayerFromName (occupant) 
			triggerClientEvent ( "radio.play", playerid)
		end
	end
end
addEvent( "radio.update", true )
addEventHandler( "radio.update", getRootElement(), UpdateRadio )