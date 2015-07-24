local skinek =  {}



function atSzallit (thePlayer,commandName,target)
local theTeam = getPlayerTeam(thePlayer)
local factionType = getElementData(theTeam, "type")
local playerCol = isInArrestColshape(thePlayer)
    if (factionType==2) and playerCol then
    if not (target) then
           outputChatBox("Parancs:/" .. commandName .. " [Játékos neve/id] [Csak cella melett hasznáható]", thePlayer, 255, 194, 14)
    else
	    local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Játékos nem online", thePlayer, 255, 0 , 0)
				else
					detachElements(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)
					local r = getPedRotation(thePlayer)
					setCameraInterior(targetPlayer, interior)
					
					
					-- Maths calculations to stop the target being stuck in the player
					x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
					y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
					
					if (isPedInVehicle(targetPlayer)) then
						local veh = getPedOccupiedVehicle(targetPlayer)
						setVehicleTurnVelocity(veh, 0, 0, 0)
						setElementPosition(veh, x, y, z + 1)
						setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
						setElementInterior(veh, interior)
						setElementDimension(veh, dimension)
						
					else
						setElementPosition(targetPlayer, x, y, z)
						setElementInterior(targetPlayer, interior)
						setElementDimension(targetPlayer, dimension)
					end
					
					outputChatBox(" Sikeresen Kivetted az előzetes cellából  " .. targetPlayerName ..  " ", thePlayer,0, 255, 0)
					if exports.global:isPlayerFullGameMaster(thePlayer) then
						outputChatBox(" Gamemaster " .. username .. "Magához teleportált ", targetPlayer)
					else
						outputChatBox("Rendőr " .. username .. " Kiszedett az előzetesből,hogy át szállitson a fegyenctelepre", targetPlayer, 0, 102, 255)
                        end
	                
                    end
				end
			end
		end
				
end
addCommandHandler("atszallit", atSzallit)




-- cells
cells =
{
	createColSphere( 227.5, 114.7, 999.02, 2 ), --1
	createColSphere( 223.5, 114.7, 999.02, 2 ), --2
	createColSphere( 219.5, 114.7, 999.02, 2 ), --3
	createColSphere( 215.5, 114.7, 999.02, 2 ), --4
		-- Sherrifs
	
	createColSphere( 1939.3173828125, -2383.236328125, 33.558120727539, 3 ),	-- 5
	createColSphere( 1934.3173828125, -2383.3759765625, 33.558120727539, 3 ), -- 6
	createColSphere( 1929.3173828125, -2383.3759765625, 33.558120727539, 3 ), -- 7	
	createColSphere( 1938.9970703125, -2369.775390625, 33.551563262939, 3 ),	-- 8
	createColSphere( 1934.3173828125, -2369.775390625, 33.551563262939, 3 ), -- 9
	createColSphere( 1929.3173828125, -2369.775390625, 33.551563262939, 3 ), -- 10
	
	

	--createColSphere(1805.1162109375, -2445.5634765625, 113.55146026611, 3 ),
	--createColSphere(1800.919921875, -2445.8955078125, 113.55146026611, 3 ),
	--createColSphere(1805.06640625, -2461.1640625, 113.55801391602, 3 ),

}

for k, v in pairs( cells ) do
	setElementInterior( v, k <= 4 and 10 )
	setElementDimension( v, k <= 4 and 78 or 78 )
	if k <= 4 then
		setElementData(v, "spawnoffset", -5, false)
	else
		setElementData(v, "spawnoffset", 0, false)
	end
end

function isInArrestColshape( thePlayer )
	for k, v in pairs( cells ) do
		if isElementWithinColShape( thePlayer, v ) and getElementDimension( thePlayer ) == getElementDimension( v ) then
			return k
		end
	end
	return false
end

function destroyJailTimer ( ) -- 0001290: PD /release bug
	local theMagicTimer = getElementData(source, "pd.jailtimer") -- 0001290: PD /release bug
	if (isTimer(theMagicTimer)) then
		killTimer(theMagicTimer) 
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailserved", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailtime", 0, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailtimer", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "pd.jailstation", false, false)
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), destroyJailTimer )

-- /arrest
function arrestPlayer(thePlayer, commandName, targetPlayerNick, fine, jailtime, ...)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if (jailtime) then
			jailtime = tonumber(jailtime)
		end
		
		local playerCol = isInArrestColshape(thePlayer)
		if (factionType==2) and playerCol then
			if not (targetPlayerNick) or not (fine) or not (jailtime) or not (...) or (jailtime<1) or (jailtime>181) then
				outputChatBox("SYNTAX: /lecsuk [Játékos neve / ID] [Birság] [börtönidő(perc 1->180)] [Büncselekmény]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local targetCol = isInArrestColshape(targetPlayer)
					
					if not targetCol then
						outputChatBox("The player is not within range of the booking desk.", thePlayer, 255, 0, 0)
					elseif targetCol ~= playerCol then
						outputChatBox("Játékos nincs a cella mellett.", thePlayer, 255, 0, 0)
					else
						local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
						local username  = getPlayerName(thePlayer)
						local reason = table.concat({...}, " ")
						
						if (jailTimer) then
							outputChatBox("Játékos már börtönben van.", thePlayer, 255, 0, 0)
						else
							local finebank = false
							local targetPlayerhasmoney = exports.global:getMoney(targetPlayer, true)
							local amount = tonumber(fine)
							if not exports.global:takeMoney(targetPlayer, amount) then
								finebank = true
								exports.global:takeMoney(targetPlayer, targetPlayerhasmoney)
								local fineleft = amount - targetPlayerhasmoney
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney-fineleft, false)
							end
						
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailserved", 0, false)
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", jailtime+1, false)
							
							toggleControl(targetPlayer,'next_weapon',false)
							toggleControl(targetPlayer,'previous_weapon',false)
							toggleControl(targetPlayer,'fire',false)
							toggleControl(targetPlayer,'aim_weapon',false)
							
							-- auto-uncuff
							local restrainedObj = getElementData(targetPlayer, "restrainedObj")
							if restrainedObj then
								toggleControl(targetPlayer, "sprint", true)
								toggleControl(targetPlayer, "jump", true)
								toggleControl(targetPlayer, "accelerate", true)
								toggleControl(targetPlayer, "brake_reverse", true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrain", 0, true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedBy", false, true)
								exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "restrainedObj", false, true)
								if restrainedObj == 45 then -- If handcuffs.. take the key
									local dbid = getElementData(targetPlayer, "dbid")
									exports['item-system']:deleteAll(47, dbid)
								end
								exports.global:giveItem(thePlayer, restrainedObj, 1)
								mysql:query_free("UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							end
							setPedWeaponSlot(targetPlayer,0)
							
							exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailstation", targetCol, false)
							
							mysql:query_free("UPDATE characters SET pdjail='1', pdjail_time='" .. mysql:escape_string(jailtime) .. "', pdjail_station='" .. mysql:escape_string(targetCol) .. "', cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. mysql:escape_string(getElementData( targetPlayer, "dbid" )) )
							outputChatBox("You jailed " .. targetPlayerNick .. " for " .. jailtime .. " Minutes.", thePlayer, 255, 0, 0)
							
							local x, y, z = getElementPosition(cells[targetCol])
							local offset = getElementData(cells[targetCol], "spawnoffset")
							setElementPosition(targetPlayer, x, y + offset, z)
							setPedRotation(targetPlayer, 0)
							
							-- Show the message to the faction
							local theTeam = getPlayerTeam(thePlayer)
							local teamPlayers = getPlayersInTeam(theTeam)

							local factionID = getElementData(thePlayer, "faction")
							local factionRank = getElementData(thePlayer, "factionrank")
														
							local factionRanks = getElementData(theTeam, "ranks")
							local factionRankTitle = factionRanks[factionRank]
							
							outputChatBox("Letartóztattak! Aki lecsukott:" .. username .. "  ennyi időre: " .. jailtime .. " perc.", targetPlayer, 0, 102, 255)
							skinek[targetPlayer]= getElementModel(targetPlayer)
							 setElementModel( targetPlayer, 150 )
							outputChatBox("Bűncselekmény oka: " .. reason .. ".", targetPlayer, 0, 102, 255)
							if (finebank == true) then
								outputChatBox("A pénzbüntetést levonták a bankszámládról!", targetPlayer, 0, 102, 255)
							end
							takeAllWeapons ( targetPlayer )
							for key, value in ipairs(teamPlayers) do
								outputChatBox(factionRankTitle .. " " .. username .. " letartóztatta " .. targetPlayerNick .. " ennyi időre: " .. jailtime .. " perc.", value, 0, 102, 255)
								outputChatBox("Bűncselekmény oka : " .. reason .. ".", value, 0, 102, 255)
							end
							timerPDUnjailPlayer(targetPlayer)
							exports.logs:logMessage("[PD/ARREST] ".. factionRankTitle .. " " .. username .. "letartóztatott egy bűnözőt, neve: " .. targetPlayerNick .. "-t ennyi időre:" .. jailtime .. " perc. Bűncselekmény oka: "..reason , 30)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("arrest", arrestPlayer)

function timerPDUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = tonumber(getElementData(jailedPlayer, "pd.jailserved"))
		local timeLeft = getElementData(jailedPlayer, "pd.jailtime")
		local username = getPlayerName(jailedPlayer)
		
		if ( timeServed ) then
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", tonumber(timeServed)+1, false)
			local timeLeft = timeLeft - 1
			exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", timeLeft, false)

			if (timeLeft<=0) then
				theMagicTimer = nil
				fadeCamera(jailedPlayer, false)
				if (getElementData(jailedPlayer, "pd.jailstation") <= 4) then
					-- LSPD
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, getElementData(jailedPlayer, "pd.jailstation") <= 4 and 0 or 0)
					setElementInterior(jailedPlayer, 0)
					setCameraInterior(jailedPlayer, 0)
					setElementPosition(jailedPlayer, -1814.0166, 107.4160, 15.1093)
					setPedRotation(jailedPlayer, 270)
				if skinek[jailedPlayer] then
                    setElementModel(jailedPlayer, skinek[jailedPlayer] )
                    skinek[jailedPlayer] = nil
					end
				else
					-- Sheriffs
					mysql:query_free("UPDATE characters SET pdjail_time='0', pdjail='0', pdjail_station='0' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
					setElementDimension(jailedPlayer, 0)
					setElementInterior(jailedPlayer, 0)
					setCameraInterior(jailedPlayer, 11)
					setElementPosition(jailedPlayer,  -1814.0166, 107.4160, 15.1093)
					setPedRotation(jailedPlayer, 90)
				end
                
				
					
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailserved", 0, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtime", 0, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", false, false)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailstation", false, false)
				
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				
				fadeCamera(jailedPlayer, true)
				outputChatBox("Börtönbüntetés lejárt legközelebb légy törvénytisztelő.", jailedPlayer, 0, 255, 0)

			elseif (timeLeft>0) then
				mysql:query_free("UPDATE characters SET pdjail_time='" .. mysql:escape_string(timeLeft) .. "' WHERE id=" .. mysql:escape_string(getElementData(jailedPlayer, "dbid")))
				local theTimer = setTimer(timerPDUnjailPlayer, 60000, 1, jailedPlayer)
				exports['anticheat-system']:changeProtectedElementDataEx(jailedPlayer, "pd.jailtimer", theTimer, false)
			end
		end
	end
end

function showJailtime(thePlayer)
	local ajailtime = getElementData(thePlayer, "jailtime")
	if ajailtime then
		outputChatBox("Neked " .. ajailtime .. " perced van még hátra az adminjail-ből!", thePlayer, 255, 194, 14)
	else
		local isJailed = getElementData(thePlayer, "pd.jailtimer")
		
		if not (isJailed) then
			outputChatBox("Nem vagy letartóztatva!", thePlayer, 255, 0, 0)
		else
			local jailtime = getElementData(thePlayer, "pd.jailtime")
			outputChatBox("Neked " .. jailtime .. " perced van még hátra a börtönből!", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("jailtime", showJailtime)

function jailRelease(thePlayer, commandName, targetPlayerNick)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		
		if factionType == 2 and isInArrestColshape(thePlayer) then
			if not (targetPlayerNick) then
				outputChatBox("SYNTAX: /release [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
			else
				local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
				if targetPlayer then
					local jailTimer = getElementData(targetPlayer, "pd.jailtimer")
					local username  = getPlayerName(thePlayer)
						
					if (jailTimer) then
						exports['anticheat-system']:changeProtectedElementDataEx(targetPlayer, "pd.jailtime", 1, false)
						timerPDUnjailPlayer(targetPlayer)
						exports.logs:logMessage("[PD/RELEASE]" .. username .. " released "..targetPlayerNick , 30)
					else
						outputChatBox("This player is not serving a jail sentence.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("release", jailRelease)