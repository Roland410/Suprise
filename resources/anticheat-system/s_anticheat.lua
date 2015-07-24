function showSpeedToAdmins(velocity)
	kph = math.ceil(velocity * 1.609344)
	exports.global:sendMessageToAdmins("[Lehetséges Speedhack/Handling Hack] " .. getPlayerName(client) .. ": " .. velocity .. " Mérföld/h / ".. kph .." Km/h")
end
addEvent("alertAdminsOfSpeedHacks", true)
addEventHandler("alertAdminsOfSpeedHacks", getRootElement(), showSpeedToAdmins)

function showDMToAdmins(kills)
	exports.global:sendMessageToAdmins("[Lehetséges DM] " .. getPlayerName(client) .. ": " .. kills .. " ölés kevesebb mint 2 perc alatt.")
end
addEvent("alertAdminsOfDM", true)
addEventHandler("alertAdminsOfDM", getRootElement(), showDMToAdmins)

-- [MONEY HACKS]
function scanMoneyHacks()
	local tick = getTickCount()
	local hackers = { }
	local hackersMoney = { }
	local counter = 0
	
	local players = exports.pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		if (logged==1) then
			if not (exports.global:isPlayerAdmin(value)) then -- Only check if its not an admin...
				
				local money = getPlayerMoney(value)
				local truemoney = exports.global:getMoney(value)
				if (money) then
					if (money > truemoney) then
						counter = counter + 1
						hackers[counter] = value
						hackersMoney[counter] = (money-truemoney)
					end
				end
			end
		end
	end
	local tickend = getTickCount()

	local theConsole = getRootElement()
	for key, value in ipairs(hackers) do
		local money = hackersMoney[key]
		local accountID = getElementData(value, "account:id")
		local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
		outputChatBox("AntiCheat: " .. targetPlayerName .. " automatikusan ki lett bannolva pénz cheat miatt. (" .. tostring(money) .. " Ft)", getRootElement(), 255, 0, 51)
	end
end
setTimer(scanMoneyHacks, 3600000, 0) -- Every 60 minutes