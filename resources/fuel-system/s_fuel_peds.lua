local mysql = exports.mysql
function startTalkToPed ()
	
	thePed = source
	thePlayer = client
	
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ)<=7) then
		return
	end

	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Mit tudok tenni érted?")
		setConvoState(thePlayer, 3)
		local responseArray = { "Fel tudod tankolni a benzines kannámat?", "Eh.. semmi.", "Tudsz passzolni egy cigit?", "Jó a pólód." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports['vehicle-system']:isVehicleWindowUp(theVehicle)) then
			outputChatBox("Le kellene tekerni az ablakot.. (( '/ablak' ))", thePlayer, 255,0,0)
			return
		end
		processMeMessage(thePed, "rátámaszkodik " .. getPlayerName(thePlayer):gsub("_"," ") .. " járművére.", thePlayer )
		processMessage(thePed, "Szia, tudok neked segíteni?")
		setConvoState(thePlayer, 1)
		local responseArray = { "Hmm, kérlek tankold meg a kocsimat.", "Nem köszönöm.", "Tudsz passzolni egy cigit?", "Fejezd be a kocsimra való támaszkodást." }
		triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
	end
end
addEvent( "fuel:startConvo", true )
addEventHandler( "fuel:startConvo", getRootElement(), startTalkToPed )


function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client
	
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end
	
	local convState = getElementData(thePlayer, "ped:convoState")
	local currSlot = getElementData(thePlayer, "languages.current")
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then -- "Hey, how could I help you?"
		local languageSkill = exports['language-system']:getSkillFromLanguage(thePlayer, 16)
		if (languageSkill < 60) or (currLang ~= 16) then
			processMessage(thePed, "Héé, haver nem értem mit beszélsz.")
			setConvoState(thePlayer, 0)
			return
		end
	
		if (answer == 1) then -- "Ehm, fill my tank up, please."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMessage(thePed, "Persze.. Mindjárt elintézzük.")
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			if (getElementData(theVehicle, "engine") == 1) then
				processMessage(thePed, "Kérlek leállítanád a motorodat?")
				local responseArray = { "Persze.", "Nem tudod megcsinálni, járó motor közben?", "Ehh, mivan?" }
				triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
				setConvoState(thePlayer, 2)
				return
			else
				pedWillFillVehicle(thePlayer, thePed)
			end
		elseif (answer == 2) then -- "No thanks."
			processMessage(thePed, "Okés, ha üzemanyagra van szükséged gyere!")
			setConvoState(thePlayer, 0)
		elseif (answer == 3) then -- "Do you have a sigarette for me?"
			processMessage(thePed, "Őhhm, nem. Ha cigi kell menj el a vegyesbe.")
			setConvoState(thePlayer, 0)
		elseif (answer == 4) then -- stop leaning against my car
			processMessage(thePed, "Oké, nyugi.")
			processMeMessage(thePed, "arrébbáll a kocsitól.", thePlayer )
			processMessage(thePed, "Nos, akkor megtankolhatom?")
			local responseArray = {  "Gyerünk!", "Nem, többet nem." }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 1)
		end
	elseif (convState == 2) then -- "Could you please turn your engine off?"
		if (answer == 1) then -- "Sure, no problemo." / "Ok, okay.."
			if not (isPedInVehicle(thePlayer)) then
				processMessage(thePed, "Ehm...")
				setConvoState(thePlayer, 0)
				return
			end
			processMeMessage(thePlayer, "leállítja a motort.",thePlayer )
			local theVehicle = getPedOccupiedVehicle(thePlayer)
			setElementData(theVehicle, "engine", 0)
			setVehicleEngineState(theVehicle, false)
			pedWillFillVehicle(thePlayer, thePed)
		elseif (answer == 2) then -- "Can't you do it with the engine running?" 
			processMeMessage(thePed, "sighs.",thePlayer )
			processMessage(thePed, "Héé ember! Én nem akarok meghalni. Megállítod vagy elmész?")
			local responseArray = {  "Megállítom.", false, false, "Úhh, fogd be."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif (answer == 3) then -- "Eh, WHAT?"
			processMessage(thePed, "Megkérdezem másodjára: le tudod állítani a motorodat?")
			local responseArray = {  "Igen", false,false, "Úhh, nem."  }
			triggerClientEvent(thePlayer, "fuel:convo", thePed, responseArray)
			setConvoState(thePlayer, 2)
		elseif answer == 4 then -- "Ugh, shut up then." / "Ugh, no."
			processMessage(thePed, "Rendben öcsisajt. El lehet innen menni.")
			setConvoState(thePlayer, 0)
		end
	elseif (convState == 3) then
		if answer == 1 then -- Could you fill my fuelcan?
			if (exports.global:hasItem(thePlayer, 57)) then
				processMessage(thePed, "Természetesen!")
				processMeMessage(thePed, "átveszi a kannát és leveszi a tankoló csövet.",thePlayer )
				processMeMessage(thePed, "lecsavarja a kanna kupakját és óvatosan teletankolja.",thePlayer )
				setTimer(pedWillFillFuelCan, 3500, 1, thePlayer, thePed)
			else
				processMessage(thePed, "Kéne neked egy benzines kanna. Ugorj be érte az egyik vegyesboltbabe.")
				setConvoState(thePlayer, 0)
			end
		elseif answer == 2 then -- No thanks
			processMessage(thePed, "Rendben, további szép napot.")
			setConvoState(thePlayer, 0)
		elseif answer == 3 then -- do you have a cigarette for me?
			processMessage(thePed, "Őhhm, nem. Ha cigi kell menj el a vegyesboltba.")
			setConvoState(thePlayer, 0)
		elseif answer == 4 then -- I like your suit
			processMessage(thePed, "Köszönöm. Én is úgy gondolom.")
			processMeMessage(thePed, "nevet.",thePlayer )
			setConvoState(thePlayer, 0)
		end
	end
end
addEvent( "fuel:convo", true )
addEventHandler( "fuel:convo", getRootElement(), talkToPed )

function pedWillFillFuelCan(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "Fine, no fuel for you!")
		return
	end
	
	local hasItem, itemSlot, itemValue, itemUniqueID = exports.global:hasItem(thePlayer, 57)
	if not (hasItem) then
		processMessage(thePed, "Vicces...")
		processMeMessage(thePed, "sóhajt.",thePlayer )
		return
	end
	
	if itemValue >= 10 then
		processMessage(thePed, "Ez már tele van..")
		return
	end
	
	local theLitres = 10 - itemValue
		
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE))
	
	if not exports.global:hasMoney(thePlayer, fuelCost) then
		processMessage(thePed, "Hogy gondoltad, miből fizetsz?! Köcsög!")
		return
	end
	
	if not (exports['item-system']:updateItemValue(thePlayer, itemSlot, itemValue + theLitres)) then
		outputChatBox("(( Valami elromlott, jelentsd: '/report'. ))", thePlayer)
		return
	end
			
	processMeMessage(thePed, "átadja a blokkot " .. getPlayerName(thePlayer):gsub("_"," ") .. " kezébe." ,thePlayer )	
	processMeMessage(thePlayer, "átveszi a blokkot és elolvassa." ,thePlayer )	
	outputChatBox("=LS Benzinkút===============", thePlayer)
	outputChatBox("Nyugta:", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " liter üzemanyag    -    " .. fuelCost .. "Ft", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "átad ".. fuelCost .."Ft-t a benzinkutas kezébe." ,thePlayer )	
	else
		processMeMessage(thePlayer, "bólint egyet és átnézi mégegyszer." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Köszönjük, hogy nálunk tankolt, jöjjön legközelebb is!")
end	


function pedWillFillVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	processMeMessage(thePed, "leveszi a tankoló csövet.",thePlayer )
	processMeMessage(thePed, "óvatosan kinyitja az autó tanksapkáját és elkezdi megtankolni..",thePlayer )
	setTimer(processMessage, 7000, 1, thePed, "Mindjárt megvan..")
	setTimer(pedWillFuelTheVehicle, 10000, 1, thePlayer, thePed)
end

function pedWillFuelTheVehicle(thePlayer, thePed)
	if not (thePlayer and isElement(thePlayer)) then
		return
	end
	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		exports['chat-system']:localShout(thePed, "do", "HÉ SEGGFEJ! MEG AKARSZ HALNI?!")
		return
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	
	if (getVehicleEngineState(theVehicle)) then
		exports['chat-system']:localShout(thePed, "do", "HÉ SEGGFEJ! MEG AKARSZ HALNI?!")
		--processDoMessage(thePlayer, "The vehicle explodes", thePlayer)
		--blowVehicle (theVehicle, false )
		return
	end
	
	if not (isPedInVehicle(thePlayer)) then
		processMessage(thePed, "Ehm...")
		setConvoState(thePlayer, 0)
		return
	end
	

		
	local theLitres, free, factionToCharge = calculateFuelPrice(thePlayer, thePed)
	local currentTax = exports.global:getTaxAmount()
	local fuelCost = math.floor(theLitres*(FUEL_PRICE + (currentTax*FUEL_PRICE)))
	if (free) then
		if factionToCharge then
			exports.global:takeMoney(factionToCharge, fuelCost, true)
		end
		fuelCost = 0
	end
	
	exports.global:takeMoney(thePlayer, fuelCost, true)
					
	local loldFuel = getElementData(theVehicle, "fuel")
	local newFuel = loldFuel+theLitres
	exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "fuel", newFuel, false)
	triggerClientEvent(thePlayer, "syncFuel", theVehicle, newFuel)
		
	processMeMessage(thePed, "átadja a blokkot " .. getPlayerName(thePlayer):gsub("_"," ") .. " kezébe." ,thePlayer )	
	processMeMessage(thePlayer, "átveszi a blokkot és elolvassa." ,thePlayer )	
	outputChatBox("=LS Benzinkút===============", thePlayer)
	outputChatBox("Nyugta:", thePlayer)
	outputChatBox("    " .. math.ceil(theLitres) .. " liter üzemanyag    -    " .. fuelCost .. "Ft", thePlayer)
	outputChatBox("============================", thePlayer)
	if (fuelCost > 0) then
		processMeMessage(thePlayer, "átad ".. fuelCost .."Ft-t a benzinkutas kezébe." ,thePlayer )	
	else
		processMeMessage(thePlayer, "bólint egyet és átnézi mégegyszer." ,thePlayer )	
	end
	setTimer(processMessage, 500, 1, thePed, "Köszönjük, hogy nálunk tankolt, jöjjön legközelebb is!")			
end

function setConvoState(thePlayer, state)
	exports['anticheat-system']:changeProtectedElementDataEx(thePlayer, "ped:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['chat-system']:localIC(thePed, message, language)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function calculateFuelPrice(thePlayer, thePed)
	local litresAffordable = MAX_FUEL
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	local currFuel = tonumber(getElementData(theVehicle, "fuel"))
	local faction = getPlayerTeam(thePlayer)
	local ftype = getElementData(faction, "type")
	local fid = getElementData(faction, "id")
	local ratio = getElementData(thePed, "fuel:priceratio") or 100
	local factionToCharge = false
	
	local free = false
	if (ftype~=2) and (ftype~=3) and (ftype~=4) and (fid~=30) and not (exports.donators:hasPlayerPerk(thePlayer, 7)) then
		local money = exports.global:getMoney(thePlayer)
				
		local tax = exports.global:getTaxAmount()
		local cost = FUEL_PRICE + (tax*FUEL_PRICE)
		local cost = (cost / 100) * ratio
		local litresAffordable = math.ceil(money/cost)
			
		if amount and amount <= litresAffordable and amount > 0 then
			litresAffordable = amount
		end
					
		if (litresAffordable>MAX_FUEL) then
			litresAffordable=MAX_FUEL
		end
	else
		if not exports.donators:hasPlayerPerk(thePlayer, 7) then
			factionToCharge = faction
			local tax = exports.global:getTaxAmount()
			local cost = FUEL_PRICE + (tax*FUEL_PRICE)
			local cost = (cost / 1000) * ratio
			local litresAffordable=MAX_FUEL
		end
		
		
		free = false
	end
	
	if (litresAffordable+currFuel>MAX_FUEL) then
		litresAffordable = MAX_FUEL - currFuel
	end
	return litresAffordable, free, factionToCharge
end

function createFuelPed(skin, posX, posY, posZ, rotZ, name, priceratio)
	local theNewPed = createPed(skin, posX, posY, posZ)
	exports.pool:allocateElement(theNewPed)
	setPedRotation(theNewPed, rotZ)
	setElementFrozen(theNewPed, true)
	--setPedAnimation(theNewPed, "FOOD", "FF_Sit_Loop",  -1, true, false, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "talk",1, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "name", name:gsub("_", " "), true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:name", name, true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:type", "fuel", true)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "ped:fuelped",true, true)
	
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "fuel:priceratio" , priceratio or 100, false)
	
	-- For the language system
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang1" , 1, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang1skill", 100, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang2" , 2, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.lang2skill", 100, false)
	exports['anticheat-system']:changeProtectedElementDataEx(theNewPed, "languages.current", 1, false)	
	createBlip(posX, posY, posZ, 55, 2, 255, 0, 0, 255, 0, 300)
	return theNewPed
end
function onServerStart()
	--[[local sqlHandler = mysql:query("SELECT * FROM fuelpeds")
	if (sqlHandler) then
		while true do
			local row = mysql:fetch_assoc( sqlHandler )
			if not row then break end
			
			createFuelPed(tonumber(row["skin"]),tonumber(row["posX"]),tonumber(row["posY"]),tonumber(row["posZ"]), tonumber(row["rotZ"]), row["name"],tonumber(row["priceratio"]))
		end
		
	end
	mysql:free_result(sqlHandler)--]]
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), onServerStart)

createFuelPed(217, 1941.7294, -1776.49, 13.64, 270, "Benzinkutas segítő", 100)
createFuelPed(217, 1941.5634, -1769.45, 13.64, 90, "Benzinkutas segítő", 100)
createFuelPed(217, 1000.3468, -937.2890, 42.32, 180, "Benzinkutas segítő", 100)
createFuelPed(217, 1007.2167, -936.2392, 42.32, 0, "Benzinkutas segítő", 100)
createFuelPed(217,2116.66, 914.90, 10.95, 0, "Benzinkutas segítő", 100)--lv kutas1
createFuelPed(217,2196.89, 2476.32, 10.95, -90, "Benzinkutas segítő", 100)--lv kutas2
createFuelPed(217,2113.41, 925.58, 10.95, 180, "Benzinkutas segítő", 100)--lv kutas3
createFuelPed(217,2638.15, 1100.79, 10.95, 0, "Benzinkutas segítő", 100)--lv kutas4
createFuelPed(217,2208.01, 2476.32, 10.95, 90, "Benzinkutas segítő", 100)--lv kutas5
createFuelPed(217,1594.30, 2204.46, 11.06, 180, "Benzinkutas segítő", 100)--lv kutas6
createFuelPed(217,1594.30, 2193.65, 11.06, 180, "Benzinkutas segítő", 100)--lv kutas
createFuelPed(217,1381.67, 460.08, 20.34, 150, "Benzinkutas segítő", 100)--falu kutas
createFuelPed(217,655.49, -557.91, 16.50, 90, "Benzinkutas segítő", 100)--falu kutas1
createFuelPed(217,655.49, -572.17, 16.50, 90, "Benzinkutas segítő", 100)--falu kutas2
createFuelPed(217,-2410.92, 968.81, 45.46, 270, "Benzinkutas segítő", 100)--sf kutas
createFuelPed(217,-2410.92, 978.94, 45.46, 270, "Benzinkutas segítő", 100)--sf kutas2
createFuelPed(217,-2026.75, 156.92, 29.03, 270, "Benzinkutas segítő", 100)--sf kutas3
createFuelPed(217,-1683.21, 412.64, 7.39, 227, "Benzinkutas segítő", 100)--sf kutas4
createFuelPed(217,-1676.22, 405.67, 7.39, 48, "Benzinkutas segítő", 100)--sf kutas5
createFuelPed(217,-1668.43, 413.72, 7.39, 48, "Benzinkutas segítő", 100)--sf kutas6
createFuelPed(217,-1675.34, 420.43, 7.39, 225, "Benzinkutas segítő", 100)--sf kutas7
createFuelPed(217,-89.38,-1174.38, 2.35, 70, "Benzinkutas segítő", 100)--sf kutas8
createFuelPed(217,-1608.76,-2715.07, 48.94, 140, "Benzinkutas segítő", 100)--sf kutas9
createFuelPed(217,-2242.45,-2563.71, 32.07, 140, "Benzinkutas segítő", 100)--sf kutas10
createFuelPed(217,73.95,1219.16, 19.11, 70, "Benzinkutas segítő", 100)--sf kutas11