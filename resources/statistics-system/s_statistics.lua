local tick = getTickCount()

-- /astats
function getAdminStats(thePlayer, commandName)
	if (exports.global:isPlayerAdmin(thePlayer)) then
		outputChatBox("-=-=-=-=-=-=-=-=-= STATISZTIKÁK =-=-=-=-=-=-=-=-=-", thePlayer, 255, 194, 14)
		
		-- CURRENT PLAYERS
		local playerCount = getPlayerCount()
		local maxCount = getMaxPlayers()
		outputChatBox("     Jelenlegi játékosok: " .. playerCount .. "/" .. maxCount , thePlayer, 255, 194, 14)
		
		-- UPTIME
		local currTick = getTickCount()
		local uptimeMilliseconds = currTick - tick
		
		local minutes = math.floor((uptimeMilliseconds/1000)/60)
		
		outputChatBox("     Üzemidő: " .. minutes .. " perc", thePlayer, 255, 194, 14)
		
		-- Queries:
		local queries = exports.mysql:returnQueryStats()
		outputChatBox("     SQL querik: " .. queries ,  thePlayer, 255, 194, 14)  

		-- Cache hits
		local cacheUsed = exports.cache:stats()
		outputChatBox("     Gyorsítótár betöltések: " .. cacheUsed ,  thePlayer, 255, 194, 14)  
		
		-- VEHICLES
		outputChatBox("     Járművek: " .. #exports.pool:getPoolElementsByType("vehicle") , thePlayer, 255, 194, 14)
	end
end
addCommandHandler("astats", getAdminStats)