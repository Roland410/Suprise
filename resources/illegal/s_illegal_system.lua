
    



--function ellopAuto(jatekos)
  --  local kocsiban = getPedOccupiedVehicle(jatekos)
	--if kocsiban then
   -- outputChatBox( "Elkezdted leszedni a műszerfalat!!!! ", jatekos, 255, 0, 0 )
	--exports.global:sendLocalDoAction(jatekos, "Valaki elkezdi szétszerelni a műszerfalat a kocsiban.")
	--setTimer(vezetek, 10000, 1, jatekos)
	--setTimer(vezetekosszekotve, 20000, 1, jatekos)
	-- toggleAllControls ( jatekos, false )
   -- else
	--outputChatBox( "Még is mit akarsz Ellopni?", jatekos, 255, 0, 0 )
	--end
--e-nd
--addCommandHandler("ellop", ellopAuto)
--function vezetek(jatekos)
 --   outputChatBox("Sikeresen elvágtad a gyújtáskapcsoló vezetékeit!", jatekos,  0, 255, 0)
  --  exports.global:sendLocalDoAction(jatekos, "Valaki Elvágja a gyújtáskapcsoló vezetékeit,és neki áll összekötözgetni.")
--end
--function vezetekosszekotve(jatekos)
 --   local veh = getPedOccupiedVehicle(jatekos)
--	local fuel = getElementData(veh, "fuel")
 --   if fuel >= 1 then
--	toggleControl(jatekos, 'brake_reverse', true)
--	 toggleAllControls ( jatekos, true )						
--	setVehicleEngineState(veh, true)
--	exports['anticheat-system']:changeProtectedElementDataEx(veh, "engine", 1, false)
--	exports.global:sendLocalDoAction(jatekos, "Valaki összekötötte a vezetéket és beindította a jármű motorját.")
--end
--end









--function matatas(jatekos,vehicle)
--    setVehicleLocked(vehicle, false)
--end


--function udvozlo(jatekos)
--outputChatBox( "Motor elinditáshoz nyomd meg a J betűt,vagy ird be /ellop", jatekos, 0, 255, 0 )
--end
--addEventHandler("onVehicleEnter",getRootElement(),udvozlo)






function illegal(thePlayer, commandName, ...)
	local theTeam = getPlayerTeam(thePlayer)
	
	if (theTeam) then
		local teamID = tonumber(getElementData(theTeam, "id"))
	
		  local illegal = {}
            for i, v in ipairs ( getElementsByType ( "player" ) ) do
                local theTeam = getPlayerTeam ( v )
                if theTeam then
                   local factionType = getElementData(theTeam, "type")
                    if (factionType==0) or (factionType==1) then
                        table.insert ( illegal, v )
                    end
                end
            end
			local message = table.concat({...}, " ")
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			
			if (factionRank<3) then
				outputChatBox("Nincs elég rangod a hazsnálatához min:rang 3.", thePlayer, 255, 0, 0)
			elseif #message == 0 then
				outputChatBox("Parancs: " .. commandName .. " [üzenet]", thePlayer, 255, 194, 14)
			else
				local ranks = getElementData(theTeam,"ranks")
				local factionRankTitle = ranks[factionRank]
				
				--exports.logs:logMessage("[IC: Government Message] " .. factionRankTitle .. " " .. getPlayerName(thePlayer) .. ": " .. message, 6)
				exports.logs:dbLog(source, 16, source, message)
		
		
					
					for i, v in ipairs( illegal ) do
					    --outputChatBox("Figyelem!!!!!! ", 229, 66, 25)
						outputChatBox("   Feketepiac: "  .. message .. " .Feladó: " .. getPlayerName(thePlayer), v, 229, 66, 25)
						---outputChatBox("Feketepiac:", "Feladó:".. getPlayerName(thePlayer), value, 0, 183, 239)
						--outputChatBox(message, value, 0, 244, 244)
					end
				end
			end
		end
addCommandHandler("illegál", illegal)