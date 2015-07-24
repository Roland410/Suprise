mysql = exports.mysql

reports = { }


local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end


function resourceStart(res)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		exports['anticheat-system']:changeProtectedElementDataEx(value, "report", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(value, "reportadmin", false, false)
	end	
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function getAdminCount()
	local online, duty, lead, leadduty, gm, gmduty = 0, 0, 0, 0,0,0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "adminlevel" ) or 0
			if level >= 1 and level <= 6 then
				online = online + 1
				
				local aod = getElementData( value, "adminduty" ) or 0
				if aod == 1 then
					duty = duty + 1
				end
				
				if level >= 4 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end
			
			local level = getElementData( value, "account:gmlevel" ) or 0
			if level >= 1 and level <= 6 then
				gm = gm + 1
				
				local aod = getElementData( value, "account:gmduty" )
				if aod == true then
					gmduty = gmduty + 1
				end
			end
		end
	end
	return online, duty, lead, leadduty, gm, gmduty
end





function showReports(thePlayer)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		outputChatBox("~~~~~~~~~ Reportok ~~~~~~~~~", thePlayer, 255, 194, 15)
		
		local count = 0
		for i = 1, 300 do
			local report = reports[i]
			if report then
				local reporter = report[1]
				local reported = report[2]
				local timestring = report[4]
				local admin = report[5]
				local isGMreport = report[8]
				
				local handler = ""
				if (isElement(admin)) then
					handler = tostring(getPlayerName(admin))
				else
					handler = "None."
				end
				if isGMreport then
					outputChatBox("GM Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. ".", thePlayer, 255, 195, 15)
				end
				if not (isGMreport  and exports.global:isPlayerAdmin(thePlayer)) then
					outputChatBox("Report #" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' reporting '" .. tostring(getPlayerName(reported)) .. "' at " .. timestring .. ". Handler: " .. handler .. ".", thePlayer, 255, 195, 15)
				end
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("None.", thePlayer, 255, 194, 15)
		else
			outputChatBox("Írd be /ri [ID] a többi infóért.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("reports", showReports, false, false)

function reportInfo(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				local isGMreport = reports[id][8]
				
				local playerID = getElementData(reporter, "playerid")
				local reportedID = getElementData(reported, "playerid")
				
				if isGMreport then
					outputChatBox(" [GM#" .. id .."] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " segitséget igényel " .. timestring .. "-kor.", thePlayer, 0, 255, 255)
				else
					outputChatBox(" [#" .. id .."] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " reportolta (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. "" .. timestring .. "-kor.", thePlayer, 0, 255, 255)
				end
				
				local reason1 = reason:sub( 0, 70 )
				local reason2 = reason:sub( 71 )
				outputChatBox(" [#" .. id .."] Indok: " .. reason1, thePlayer, 0, 255, 255)
				if reason2 and #reason2 > 0 then
					outputChatBox(" [#" .. id .."] " .. reason2, thePlayer, 0, 255, 255)
				end
				
				local handler = ""
				if (isElement(admin)) then
					outputChatBox(" [#" .. id .."] Ezt a jelentést küldte " .. getPlayerName(admin) .. ".", thePlayer, 0, 255, 255)
				else
					outputChatBox(" [#" .. id .."] Írd be /ar " .. id .. ", hogy elfogadd a reportot.", thePlayer, 0, 255, 255)
				end
			else
				outputChatBox("Hibás report ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function playerQuit()
	local report = getElementData(source, "report")
	local update = false
	
	if report and reports[report] then
		local theAdmin = reports[report][5]
		local isGMreport = reports[report][8]
		
		if (isElement(theAdmin)) then
			if isGMreport then
				outputChatBox(" [GM#" .. report .."] Játékos " .. getPlayerName(source) .. " elhagyta a szervert.", theAdmin, 0, 255, 255)
			else
				outputChatBox(" [#" .. report .."] Játékos " .. getPlayerName(source) .. " elhagyta a szervert.", theAdmin, 0, 255, 255)
			end
		else
			if isGMreport then
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "adminduty")
					if adminduty == 1 then
						outputChatBox(" [#" .. report .."] Játékos " .. getPlayerName(source) .. " elhagyta a szervert.", value, 0, 255, 255)
						update = true
					end
				end
			else
				for key, value in ipairs(exports.global:getGameMasters()) do
					local adminduty = getElementData(value, "account:gmduty")
					if adminduty == true then
						outputChatBox(" [GM#" .. report .."] Játékos " .. getPlayerName(source) .. " elhagyta a szervert.", value, 0, 255, 255)
						update = true
					end
				end			
			end
		end
		
		local alertTimer = reports[report][6]
		local timeoutTimer = reports[report][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end
		
		reports[report] = nil -- Destroy any reports made by the player
		update = true
	end
	
	-- check for reports assigned to him, unassigned if neccessary
	if isGMreport then
		for i = 1, 300 do
			if reports[i] then
				if reports[i][5] == source then
					reports[i][5] = nil
					for key, value in ipairs(exports.global:getGameMasters()) do
						local adminduty = getElementData(value, "account:gmduty")
						if adminduty == true then
							outputChatBox(" [GM#" .. i .."] Report nem elérhetõ (" .. getPlayerName(source) .. " elhagyta a szervert)", value, 0, 255, 255)
							update = true
						end
					end
				end
				if reports[i][2] == source then
					for key, value in ipairs(exports.global:getGameMasters()) do
						local adminduty = getElementData(value, "account:gmduty")
						if adminduty == true then
							outputChatBox(" [GM#" .. i .."] Reportoló játékos " .. getPlayerName(source) .. " elhagyta a szervert.", value, 0, 255, 255)
							update = true
						end
					end
					
					local reporter = reports[i][1]
					if reporter ~= source then
						outputChatBox("A te reportodat GM#" .. i .. " bezárta (" .. getPlayerName(source) .. " elhagyta a szervert)", reporter, 255, 194, 14)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "report", false, false)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					end
					
					local alertTimer = reports[i][6]
					local timeoutTimer = reports[i][7]

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[i] = nil -- Destroy any reports made by the player
				end
			end
		end
	else
		for i = 1, 300 do -- Support 128 reports at any one time, since each player can only have one report
			if reports[i] then
				if reports[i][5] == source then
					reports[i][5] = nil
					for key, value in ipairs(exports.global:getAdmins()) do
						local adminduty = getElementData(value, "adminduty")
						if adminduty == 1 then
							outputChatBox(" [#" .. i .."] Report nem elérhetõ (" .. getPlayerName(source) .. " elhagyta a szervert)", value, 0, 255, 255)
							update = true
						end
					end
				end
				if reports[i][2] == source then
					for key, value in ipairs(exports.global:getAdmins()) do
						local adminduty = getElementData(value, "adminduty")
						if adminduty == 1 then
							outputChatBox(" [#" .. i .."] Reported játékos " .. getPlayerName(source) .. " elhagyta a szervert.", value, 0, 255, 255)
							update = true
						end
					end
					
					local reporter = reports[i][1]
					if reporter ~= source then
						outputChatBox("A te reportodat #" .. i .. " bezárta (" .. getPlayerName(source) .. " elhagyta a szervert)", reporter, 255, 194, 14)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "report", false, false)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					end
					
					local alertTimer = reports[i][6]
					local timeoutTimer = reports[i][7]

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[i] = nil -- Destroy any reports made by the player
				end
			end
		end	
	end
	
	
end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
	
function handleReport(reportedPlayer, reportedReason, isGMreport)
	if not isGMreport then
		isGMreport = false
	end
	
	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("Akit reportoltál éppen nincs bejelentkezve.", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil
	
	for i = 1, 300 do 
		if not reports[i] then
			slot = i
			break
		end
	end
	
	local hours, minutes = getTime()
	
	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end
	
	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end
	
	local timestring = hours .. ":" .. minutes
	

	local alertTimer = setTimer(alertPendingReport, 120000, 2, slot)
	local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, slot)
	
	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][7] = timeoutTimer -- Timeout timer of the report
	reports[slot][8] = isGMreport -- Type report
	
	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	
	exports['anticheat-system']:changeProtectedElementDataEx(source, "report", slot, false)
	exports['anticheat-system']:changeProtectedElementDataEx(source, "reportadmin", false)
	local count = 0
	local skipadmin = false
	if isGMreport then
		exports['anticheat-system']:changeProtectedElementDataEx(source, "gmreport", slot, false)
		local GMs = exports.global:getGameMasters()
		
		-- Show to GMs
		local reason1 = reportedReason:sub( 0, 70 )
		local reason2 = reportedReason:sub( 71 )
		for key, value in ipairs(GMs) do
			local gmDuty = getElementData(value, "account:gmduty")
			if (gmDuty == true) then
				outputChatBox(" [GM #" .. slot .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " segítséget kér. Indok:", value, 0, 255, 255)
				outputChatBox(" [GM #" .. slot .. "] " .. reason1, value, 0, 255, 255)
				if reason2 and #reason2 > 0 then
					outputChatBox(" [GM#" .. slot .. "] " .. reason2, value, 0, 255, 255)
				end
				skipadmin = true
			end
			count = count + 1
		end
		
		
		-- No GMS online
		if not skipadmin then
			local GMs = exports.global:getAdmins()
			-- Show to GMs
			local reason1 = reportedReason:sub( 0, 70 )
			local reason2 = reportedReason:sub( 71 )
			for key, value in ipairs(GMs) do
				local gmDuty = getElementData(value, "adminduty")
				if (gmDuty == 1) then
					outputChatBox(" [GM#" .. slot .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " segítséget kér. Indok:", value, 0, 255, 255)
					outputChatBox(" [GM#" .. slot .. "] Indok: " .. reason1, value, 0, 255, 255)
					if reason2 and #reason2 > 0 then
						outputChatBox(" [GM#" .. slot .. "] " .. reason2, value, 0, 255, 255)
					end
				end
				count = count - 1
			end			
		end
		
		outputChatBox("[" .. timestring .. "] Köszönjük, hogy elküldted a reportodat. A te reportod ID-je: #" .. tostring(slot) .. ".", source, 255, 194, 14)
		if count < 0 then
			outputChatBox("[" .. timestring .. "] Jelenleg 0 GM van ONLINE" .. ( count == 1 and "" or "s" ) .. " kérdezz adminokat..", source, 255, 194, 14)
		elseif count == 0 then
			outputChatBox("[" .. timestring .. "] Jelenleg 0 GM van ONLINE kérlek várj türelemmel.", source, 255, 194, 14)
		else
			outputChatBox("[" .. timestring .. "] Egy GM fog válaszolni a kérdésedre/kérésedre, mivel van fent " .. count .. " GM" .. ( count == 1 and "" or "s" ) .. " available.", source, 255, 194, 14)
		end
		
		outputChatBox("[" .. timestring .. "] Ha már nem jogos a report akkor /endreport.", source, 255, 194, 14)
		
	else
		local admins = exports.global:getAdmins()
		local count = 0
		-- Show to admins
		local reason1 = reportedReason:sub( 0, 70 )
		local reason2 = reportedReason:sub( 71 )
		for key, value in ipairs(admins) do
			local adminduty = getElementData(value, "adminduty")
			if (adminduty==1) then
				outputChatBox(" [#" .. slot .. "] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reportolta (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " " .. timestring .. "-kor.", value, 0, 255, 255)
				outputChatBox(" [#" .. slot .. "] Indok: " .. reason1, value, 0, 255, 255)
				if reason2 and #reason2 > 0 then
					outputChatBox(" [#" .. slot .. "] " .. reason2, value, 0, 255, 255)
				end
			end
			if getElementData(value, "hiddenadmin") ~= 1 then
				count = count + 1
			end
		end
		
		outputChatBox("[" .. timestring .. "] Köszönjük, hogy elküldted a reportodat az adminoknak. Report ID: #" .. tostring(slot) .. ".", source, 255, 194, 14)
		outputChatBox("[" .. timestring .. "] Reportoltad (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. "játékost . Indok: ", source, 255, 194, 14 )
		outputChatBox("[" .. timestring .. "] " .. reason1, source, 255, 194, 14)
		if reason2 and #reason2 > 0 then
			outputChatBox("[" .. timestring .. "] " .. reason2, source, 255, 194, 14)
		end
		outputChatBox("[" .. timestring .. "] Egy admin válaszolni fog neked mivel van " .. count .. " ONLINE admin" .. ( count == 1 and "" or "s" ) .. " available.", source, 255, 194, 14)
		outputChatBox("[" .. timestring .. "] Ha már nem jogos a report akkor /endreport.", source, 255, 194, 14)
	end

end

function GMhandleReport(reportedReason)
	handleReport(client, reportedReason, true)
end
addEvent("GMclientSendReport", true)
addEventHandler("GMclientSendReport", getRootElement(), GMhandleReport)

addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)





function alertPendingReport(id)
	if (reports[id]) then
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		local isGMreport = reports[id][8]
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")
		
		if isGMreport then
			local GMs = exports.global:getGameMasters()
			local reason1 = reportedReason:sub( 0, 70 )
			local reason2 = reportedReason:sub( 71 )
			for key, value in ipairs(GMs) do
				local gmduty = getElementData(value, "account:gmduty")
				if (gmduty== true) then
					outputChatBox(" [GM#" .. id .. "] még nem megválaszolt report: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " óta " .. timestring .. ".", value, 0, 255, 255)
					--outputChatBox(" [GM#" .. id .. "] " .. "Reason: " .. reason1, value, 0, 255, 255)
					--if reason2 and #reason2 > 0 then
					--	outputChatBox(" [GM#" .. id .. "] " .. reason2, value, 0, 255, 255)
					--end
				end
			end
		else
			local admins = exports.global:getAdmins()
			-- Show to admins
			local reason1 = reportedReason:sub( 0, 70 )
			local reason2 = reportedReason:sub( 71 )
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "adminduty")
				if (adminduty==1) then
					outputChatBox(" [#" .. id .. "] még nem megválaszolt report: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reportolta (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " " .. timestring .. "-kor.", value, 0, 255, 255)
					--outputChatBox(" [#" .. id .. "] " .. "Reason: " .. reason1, value, 0, 255, 255)
					--if reason2 and #reason2 > 0 then
					--	outputChatBox(" [#" .. id .. "] " .. reason2, value, 0, 255, 255)
					--end
				end
			end
		end
	end
end

function pendingReportTimeout(id)
	if (reports[id]) then
		
		local reportingPlayer = reports[id][1]
		local isGMreport = reports[id][8]
		-- Destroy the report
		local alertTimer = reports[id][6]
		local timeoutTimer = reports[id][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end
		
		reports[id] = nil -- Destroy any reports made by the player
		
		
		exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", false, false)
		
		local hours, minutes = getTime()
		
		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end
		
		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end
		
		local timestring = hours .. ":" .. minutes
		
		if isGMreport then
			exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "gmreport", false, false)
			local GMs = exports.global:getGameMasters()
			for key, value in ipairs(GMs) do
				local gmduty = getElementData(value, "account:gmduty")
				if (gmduty== true) then
					outputChatBox(" [GM#" .. id .. "] - REPORT #" .. id .. " lejárt!", value, 0, 255, 255)
				end
			end
		else
			exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "report", false, false)
			local admins = exports.global:getAdmins()
			-- Show to admins
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "adminduty")
				if (adminduty==1) then
					outputChatBox(" [#" .. id .. "] - REPORT #" .. id .. " lejárt!", value, 0, 255, 255)
				end
			end
		end
		
		outputChatBox("[" .. timestring .. "] A te reportod (#" .. id .. ") lejárt.", reportingPlayer, 255, 194, 14)
		outputChatBox("[" .. timestring .. "] Ha fontosnak tartod a reportot akkor írd meg újra, vagy írj a fórumon (http://mégnincs.majdlesz).", reportingPlayer, 255, 194, 14)

		
	end
end

function falseReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Hibás report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					outputChatBox("Report #" .. id .. " kezelés alatt áll " .. getPlayerName(reportHandler) .. " által.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					local isGMreport = reports[id][8]
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[id] = nil
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local timestring = hours .. ":" .. minutes
					
					exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", false, false)
					outputChatBox("[" .. timestring .. "] A reportod (#" .. id .. ") hamisnak lett vélve " .. getPlayerName(thePlayer) .. " által.", reportingPlayer, 255, 194, 14)
					
					if isGMreport then
						exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "gmreport", false, false)
						local admins = exports.global:getGameMasters()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "account:gmduty")
							if (adminduty== true) then
								outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(thePlayer) .. " megjelölte a reportot #" .. id .. " hamisnak. -", value, 0, 255, 255)
							end
						end					
					else
						exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "report", false, false)
						local admins = exports.global:getAdmins()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "adminduty")
							if (adminduty==1) then
								outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " megjelölte a reportot #" .. id .. " hamisnak. -", value, 0, 255, 255)
							end
						end
					end
					
					
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

function arBind()
	for k, arrayPlayer in ipairs(exports.global:getAdmins()) do
		local logged = getElementData(arrayPlayer, "loggedin")
		if (logged) then
			if exports.global:isPlayerLeadAdmin(arrayPlayer) then
				outputChatBox( "LeadAdmWarn: " .. getPlayerName(client) .. " köteles elfogadni a reportot. ", arrayPlayer, 255, 194, 14)
			end
		end
	end
end
addEvent("arBind", true)
addEventHandler("arBind", getRootElement(), arBind)

function acceptReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Hibás report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]
				
				if (reportHandler) then
					outputChatBox("Report #" .. id .. " kezelés alatt áll " .. getPlayerName(reportHandler) .. " által.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					local isGMreport = reports[id][8]
					
					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end
					
					reports[id][5] = thePlayer -- Admin dealing with this report
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
					
					local adminreports = getElementData(thePlayer, "adminreports")
					exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "adminreports", adminreports+1, false)
					mysql:query_free("UPDATE accounts SET adminreports=adminreports+1 WHERE id = " .. mysql:escape_string(getElementData( thePlayer, "account:id" )) )
					exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", thePlayer, false)
					
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					
					if (exports.global:isPlayerAdmin(thePlayer)) then
						outputChatBox("[" .. timestring .. "] Adminisztrátor " .. getPlayerName(thePlayer) .. " elfogadta a reportodat (#" .. id .. "), Kérlek várj míg segít neked.", reportingPlayer, 255, 194, 14)
						executeCommandHandler("check", thePlayer, tostring(playerID))
					else
						outputChatBox("[" .. timestring .. "] Gamemaster " .. getPlayerName(thePlayer) .. " elfogadta a reportodat (#" .. id .. "), Kérlek várj míg segít neked.", reportingPlayer, 255, 194, 14)
					end
					outputChatBox("Elfogadtad a #" .. id .. "IDjû reportot. Kérlek segíts a játékosnak ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", thePlayer, 255, 194, 14)
					
					if isGMreport then
						local admins = exports.global:getGameMasters()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "account:gmduty")
							if (adminduty==true) then
								outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(thePlayer) .. " elfogadta a reportot #" .. id .. " -", value, 0, 255, 255)
							end
						end
					else
						local admins = exports.global:getAdmins()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "adminduty")
							if (adminduty==1) then
								outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " elfogadta a reportot #" .. id .. " -", value, 0, 255, 255)
							end
						end					
					end
					
					
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function acceptAdminReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID] [Adminnév]", thePlayer, 255, 194, 14)
		else
			local targetAdmin, username = exports.global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Hibás report ID.", thePlayer, 255, 0, 0)
				else
					local reportHandler = reports[id][5]
					
					if (reportHandler) then
						outputChatBox("Report #" .. id .. " kezelés alatt áll " .. getPlayerName(reportHandler) .. " által.", thePlayer, 255, 0, 0)
					else
						local reportingPlayer = reports[id][1]
						local reportedPlayer = reports[id][2]
						local alertTimer = reports[id][6]
						local timeoutTimer = reports[id][7]
						local isGMreport = reports[id][8]
						if isTimer(alertTimer) then
							killTimer(alertTimer)
						end
						
						if isTimer(timeoutTimer) then
							killTimer(timeoutTimer)
						end
						
						reports[id][5] = targetAdmin -- Admin dealing with this report
						
						local hours, minutes = getTime()
						
						-- Fix hours
						if (hours<10) then
							hours = "0" .. hours
						end
						
						-- Fix minutes
						if (minutes<10) then
							minutes = "0" .. minutes
						end
						
						local adminreports = getElementData(targetAdmin, "adminreports")
						exports['anticheat-system']:changeProtectedElementDataEx(targetAdmin, "adminreports", adminreports+1, false)
						mysql:query_free("UPDATE accounts SET adminreports=adminreports+1 WHERE id = " .. mysql:escape_string(getElementData( targetAdmin, "account:id" )) )
						exports['anticheat-system']:changeProtectedElementDataEx(reportingPlayer, "reportadmin", targetAdmin, false)
						
						local timestring = hours .. ":" .. minutes
						local playerID = getElementData(reportingPlayer, "playerid")
						
						if exports.global:isPlayerGameMaster(targetAdmin) then
							outputChatBox("[" .. timestring .. "] Gamemaster " .. getPlayerName(targetAdmin) .. " elfogadta a reportodat (#" .. id .. "), Kérlek várj míg segít neked.", reportingPlayer, 255, 194, 14)
						else
							outputChatBox("[" .. timestring .. "] Adminisztrátor " .. getPlayerName(targetAdmin) .. " elfogadta a reportodat (#" .. id .. "), Kérlek várj míg segít neked.", reportingPlayer, 255, 194, 14)
						end
						outputChatBox("Elfogadtad a #" .. id .. "IDjû reportot. Kérlek segíts a játékosnak ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 255, 194, 14)
						
						if isGMreport then
							local admins = exports.global:getGameMasters()
							for key, value in ipairs(admins) do
								local adminduty = getElementData(value, "account:gmduty")
								if (adminduty==true) then
									outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(theAdmin) .. " elfogadta a reportot #" .. id .. " (Kijelölt) -", value, 0, 255, 255)
								end
							end
						else
							local admins = exports.global:getAdmins()
							for key, value in ipairs(admins) do
								local adminduty = getElementData(value, "adminduty")
								if (adminduty==1) then
									outputChatBox(" [#" .. id .. "] - " .. getPlayerName(theAdmin) .. " elfogadta a reportot #" .. id .. " (Kijelölt) -", value, 0, 255, 255)
								end
							end
						end
						
						
					end
				end
			end
		end
	end
end
addCommandHandler("ara", acceptAdminReport, false, false)


function transferReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Report ID] [Adminnév]", thePlayer, 255, 194, 14)
		else
			local targetAdmin, username = exports.global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Hibás report ID.", thePlayer, 255, 0, 0)
				elseif (reports[id][5] ~= thePlayer) and not (exports.global:isPlayerLeadAdmin(thePlayer)) then
					outputChatBox("Ez nem a te reportod.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local isGMreport = reports[id][8]
					reports[id][5] = targetAdmin -- Admin dealing with this report
					
					local hours, minutes = getTime()
					
					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end
					
					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end
							
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")
					
					outputChatBox("[" .. timestring .. "] " .. getPlayerName(thePlayer) .. " átadta a reportodat ".. getPlayerName(targetAdmin) .." nevû adminnak (#" .. id .. "), Kérlek várj míg segít neked.", reportingPlayer, 255, 194, 14)
					outputChatBox(getPlayerName(thePlayer) .. " átadta a reportot #" .. id .. " neked. Kérlek akkor segíts, te a játékosnak ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 255, 194, 14)
					
					if isGMreport then
						local admins = exports.global:getGameMasters()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "account:gmduty")
							if (adminduty==true) then
								outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(thePlayer) .. " átadta a reportot #" .. id .. " neki: ".. getPlayerName(targetAdmin) , value, 0, 255, 255)
							end
						end					
					else
						local admins = exports.global:getAdmins()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "adminduty")
							if (adminduty==1) then
								outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " átadta a reportot #" .. id .. " neki: ".. getPlayerName(targetAdmin) , value, 0, 255, 255)
							end
						end
					end
						
					
				end
			end
		end
	end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function closeReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("Hibás Report ID.", thePlayer, 255, 0, 0)
			elseif (reports[id][5] ~= thePlayer) then
				outputChatBox("Ez nem a te reportod.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local alertTimer = reports[id][6]
				local timeoutTimer = reports[id][7]
				local isGMreport = reports[id][8]
				
				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end
				
				if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end
				
				reports[id] = nil

				if (isElement(reporter)) then
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "report", false, false)
					exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					outputChatBox(getPlayerName(thePlayer) .. " befejezte a reportodat.", reporter, 0, 255, 255)
				end
				
				if not isGMreport then
					local admins = exports.global:getAdmins()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "adminduty")
						if (adminduty==1) then
							outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " befejezte a reportot #" .. id .. ". -", value, 0, 255, 255)
						end
					end					
				else
					local admins = exports.global:getGameMasters()
					for key, value in ipairs(admins) do
						local adminduty = getElementData(value, "account:gmduty")
						if (adminduty==true) then
							outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(thePlayer) .. " befejezte a reportot #" .. id .. ". -", value, 0, 255, 255)
						end
					end
				end
				
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function dropReport(thePlayer, commandName, id)
	if (exports.global:isPlayerAdmin(thePlayer) or exports.global:isPlayerGameMaster(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id] == nil) then
				outputChatBox("Hibás Report ID.", thePlayer, 255, 0, 0)
			else
				if (reports[id][5] ~= thePlayer) then
					outputChatBox("Nem te kezeled ezt a reportot.", thePlayer, 255, 0, 0)
				else
					local alertTimer = setTimer(alertPendingReport, 120000, 2, id)
					local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, id)

					reports[id][5] = nil
					reports[id][6] = alertTimer
					reports[id][7] = timeoutTimer

					local reporter = reports[id][1]
					if (isElement(reporter)) then
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "report", false, false)
						exports['anticheat-system']:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
						outputChatBox(getPlayerName(thePlayer) .. " felszabadította a reportodat. Várj míg egy admin elfogadja.", reporter, 0, 255, 255)
					end
					
					if reports[id][8] then
						local admins = exports.global:getGameMasters()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "account:gmduty")
							if (adminduty==true) then
								outputChatBox(" [GM#" .. id .. "] - " .. getPlayerName(thePlayer) .. " kidobta a reportot #" .. id .. ". -", value, 0, 255, 255)
							end
						end
					else
						local admins = exports.global:getAdmins()
						for key, value in ipairs(admins) do
							local adminduty = getElementData(value, "adminduty")
							if (adminduty==1) then
								outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " kidobta a reportot #" .. id .. ". -", value, 0, 255, 255)
							end
						end
					end

					
				end
			end
		end
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)

function endReport(thePlayer, commandName)
	local report = getElementData(thePlayer, "report")
	
	if not (report) or not reports[report] then
		outputChatBox("Nem küldtél jelentést! Az F2-vel és megteheted.", thePlayer, 255, 0, 0)
	else
		local hours, minutes = getTime()
					
		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end
					
		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end
					
		local timestring = hours .. ":" .. minutes
		local reportHandler = reports[report][5]
		local alertTimer = reports[report][6]
		local timeoutTimer = reports[report][7]
		
		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end
		
		if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end

		reports[report] = nil
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "report", false, false)
		exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)
		
		outputChatBox("[" .. timestring .. "] Befejezted a reportodat (#" .. report .. ").", thePlayer, 255, 194, 14)
		
		if (isElement(reportHandler)) then
			outputChatBox(getPlayerName(thePlayer) .. " befejezte a reportot (#" .. report .. "). Köszönjük, hogy kezelted a reportot.", reportHandler, 0, 255, 255)
		end
		
	end
end
addCommandHandler("endreport", endReport, false, false)