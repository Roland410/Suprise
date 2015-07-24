mysql = exports.mysql





function playerDeath(totalAmmo, killer, killerWeapon )
     
	if getElementData(source, "dbid") then
		if getElementData(source, "adminjailed") then
			spawnPlayer(source, 1649.7695,1776.3857,512.8187, 270, getElementModel(source), 11, getElementData(source, "playerid")+65400, getPlayerTeam(source))
			setCameraInterior(source, 11)
			setCameraTarget(source)
			fadeCamera(source, true)
			
			
			
			exports.logs:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "pd.jailtimer") then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			
			exports.logs:dbLog(source, 34, source, "died in police jail")
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' meghalt'
			
			if (killer) then
				killstr = ' Megölte '..getPlayerName(killer).. ' ('..getWeaponNameFromID ( killerWeapon )..')'
				table.insert(affected, killer)
			end
			setTimer(respawnPlayer, 10000, 1, source)
			
			
			exports.logs:dbLog(source, 34, affected, killstr)
			logMe(" [Halál] "..getPlayerName(source) .. killstr)
			
		end
	end
end

addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.global:isPlayerAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("ölési lista:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox(" Vége", thePlayer)
	end
end
addCommandHandler("showkills", readLog)
addCommandHandler("showkills2", readLog)

function respawnPlayer(thePlayer)
	if (isElement(thePlayer)) then
	
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer).." died while not in character, triggering blackfade.")
			return
		end
		
		local cost = math.random(175, 12000)		
		local tax = exports.global:getTaxAmount()
		
		exports.global:giveMoney( getTeamFromName("Omsz"), math.ceil((1-tax)*cost) )
		exports.global:takeMoney( getTeamFromName("Omsz"), math.ceil((1-tax)*cost) )
			
		mysql:query_free("UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. mysql:escape_string(getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)
        exports.global:setMoney(thePlayer, 0)

		
		
		-- take all drugs
		local count = 0
		for i = 30, 43 do
			while exports.global:hasItem(thePlayer, i) do
				local number = exports['item-system']:countItems(thePlayer, i)
				exports.global:takeItem(thePlayer, i)
				exports.logs:logMessage("[LSES Death] " .. getElementData(thePlayer, "account:username") .. "/" .. getPlayerName(thePlayer) .. " lost "..number.."x item "..tostring(i), 28)
				exports.logs:dbLog(thePlayer, 34, thePlayer, "lost "..number.."x item "..tostring(i))
				count = count + 1
			end
		end
		if count > 0 then
			outputChatBox("Ápoló:Tiltott dolgokat elkoboztuk majd átadtuk a rendőrségnek.", thePlayer, 255, 194, 14)
		end
		
		-- take guns
		local gunlicense = tonumber(getElementData(thePlayer, "license.gun"))
		local team = getPlayerTeam(thePlayer)
		local factiontype = getElementData(team, "type")
		local items = exports['item-system']:getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
		local removedWeapons
		local correction = 0
		for itemSlot, itemCheck in ipairs(items) do
			if (itemCheck[1] == 115) or (itemCheck[1] == 116) then -- Weapon
				-- itemCheck[2]: [1] = gta weapon id, [2] = serial number/Amount of bullets, [3] = weapon/ammo name
				local itemCheckExplode = exports.global:explode(":", itemCheck[2])
				local weapon = tonumber(itemCheckExplode[1])
				if (((weapon >= 16 and weapon <= 40 and gunlicense == 0) or weapon == 29 or weapon == 30 or weapon == 32 or weapon ==31 or weapon == 34) and factiontype ~= 2) or (weapon >= 35 and weapon <= 38)  then -- (weapon == 4 or weapon == 8)
					exports['item-system']:takeItemFromSlot(thePlayer, itemSlot - correction)
					correction = correction + 1
					
					if (itemCheck[1] == 115) then
						exports.logs:dbLog(thePlayer, 34, thePlayer, "elvesztett fegyver(" ..  itemCheck[2] .. ")")
					else
						exports.logs:dbLog(thePlayer, 34, thePlayer, "elvesztett lőszer (" ..  itemCheck[2] .. ")")
					end
					
					if (removedWeapons == nil) then
						removedWeapons = itemCheckExplode[3]
					else
						removedWeapons = removedWeapons .. ", " .. itemCheckExplode[3]
					end
				end
			end
		end
		
		if (removedWeapons~=nil) then
			if gunlicense == 0  then
				outputChatBox("A fegyvereket öntől elvettük. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			else
				outputChatBox("A fegyvereket öntől elvettük. (" .. removedWeapons .. ").", thePlayer, 255, 194, 14)
			end
		end
		
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)



		if getElementDimension(thePlayer) == 763 then
        spawnPlayer(thePlayer, 1317.2324, -1363.8378, 4094.2258,134,theSkin, 0, 0, theTeam)
        outputChatBox ("FLYMTA: Paintball pályán haltál meg ezért vegyél fel új fegyvereket vagy ha nem akarsz játszani ird be /paintballvége",thePlayer, 0, 250, 0, false)
        setTimer(korhazKi, 300000, 1, thePlayer)		
		setElementDimension( thePlayer,763 )
        setElementInterior(thePlayer , 11 )
       else
       spawnPlayer(thePlayer, 1154.0156, -1311.8251, 13.5687, 134, theSkin, 0, 0, theTeam)
	   -- outputChatBox("Los Santosi Kórházban ápolnak!", thePlayer,  0, 255, 0)
		outputChatBox("Mivel meghaltál ezért minden készpénzed elveszett!!!", thePlayer, 255, 255, 0)
		outputChatBox("Önt a los santosi kórházban ápolják..(Kezelés ideje 5 perc)", thePlayer, 255, 255, 0)
		setTimer(korhazLs, 300000, 1, thePlayer)
	   setElementDimension( thePlayer,3 )
       setElementInterior(thePlayer , 15 )
	   end

				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)
		

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		
	end
end
function korhazLs(thePlayer)
	setElementPosition(thePlayer, 1173.3759, -1323.7031, 15.3926)
	outputChatBox("Sikeresen felépültél legközelebb vigyázz magadra!", thePlayer,  0, 255, 0)
	setElementDimension( thePlayer,0 )
    setElementInterior(thePlayer , 0 )
end