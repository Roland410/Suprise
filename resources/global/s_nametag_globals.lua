function updateNametagColor(thePlayer)
	if getElementData(thePlayer, "loggedin") ~= 1 then -- Not logged in
		setPlayerNametagColor(thePlayer, 127, 127, 127)
	elseif isPlayerAdmin(thePlayer) and getElementData(thePlayer, "adminduty") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then -- Admin duty
		setPlayerNametagColor(thePlayer, 255, 0, 0)
	elseif exports.donators:hasPlayerPerk(thePlayer, 11) then -- Donator
		setPlayerNametagColor(thePlayer, 167, 133, 63)
	elseif isPlayerGameMaster(thePlayer) and getElementData(thePlayer, "account:gmduty") then -- as duty
		setPlayerNametagColor(thePlayer, 0, 255, 0)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
end

for key, value in ipairs( getElementsByType( "player" ) ) do
	updateNametagColor( value )
end	