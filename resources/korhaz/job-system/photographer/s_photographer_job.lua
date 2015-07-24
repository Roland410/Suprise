function getPaid(collectionValue)
	exports.global:giveMoney(getPlayerTeam(source), tonumber(collectionValue))
	
	local gender = getElementData(source, "gender")
	local genderm = "his"
	if (gender == 1) then
		genderm = "her"
	end
	
	exports.global:sendLocalMeAction(source,"kéz" .. genderm .. "fotóanyaggal a nő a pult mögött.")
	exports.global:sendLocalText(source, "Victoria Greene mondja: Köszönöm. Embereknek az kell, hogy a reggeli kiadás. Csak így tovább a jó munkát.", nil, nil, nil, 10)
	outputChatBox("#FF9933Hírek készültek Ft".. exports.global:formatMoney(collectionValue) .." a fényképeket.", source, 255, 104, 91, true)
	exports.global:sendMessageToAdmins("Hirek: " .. tostring(getPlayerName(source)) .. " eladott Fényképek Ft" .. exports.global:formatMoney(collectionValue) .. ".")
	exports.logs:logMessage(tostring(getPlayerName(source)) .. " eladott Fényképekr Ft" .. exports.global:formatMoney(collectionValue) .. ".", 10)
	updateCollectionValue(0)
end
addEvent("submitCollection", true)
addEventHandler("submitCollection", getRootElement(), getPaid)


function info()
	exports.global:sendLocalText(source, "Victoria Greene mondja: Hello, Úr. Elviszem a képek a Sun hírek Fényképészéhez", nil, nil, nil, 10)
	exports.global:sendLocalText(source, "de úgy tűnik, nem egy. Nyugodtan alkalmazni SAN bármikor ((a fórumokon))!", nil, nil, nil, 10)
end
addEvent("sellPhotosInfo", true)
addEventHandler("sellPhotosInfo", getRootElement(), info)

function updateCollectionValue(value)
	mysql:query_free("UPDATE characters SET photos = " .. mysql:escape_string((tonumber(value) or 0)) .. " WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
end
addEvent("updateCollectionValue", true)
addEventHandler("updateCollectionValue", getRootElement(), updateCollectionValue)

addEvent("getCollectionValue", true)
addEventHandler("getCollectionValue", getRootElement(),
	function()
		if getElementData( source, "loggedin" ) == 1 then
			local result = mysql:query_fetch_assoc("SELECT photos FROM characters WHERE id = " .. mysql:escape_string(getElementData(source, "dbid")) )
			if result then
				triggerClientEvent( source, "updateCollectionValue", source, tonumber( result["photos"] ) )
			end
		end
	end
)

function sanAD()
	exports['global']:sendLocalText(source, "Victoria Greene mondja: Hívhatja fel ügyfélszolgálati feladni hirdetést. A szám 7331.", 255, 255, 255, 10)
end
addEvent("cSANAdvert", true)
addEventHandler("cSANAdvert", getRootElement(), sanAD)

function photoHeli(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local teamType = getElementData(theTeam, "type")
	if teamType == 6 then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			local vehicleModel = getElementModel(theVehicle)
			if vehicleModel == 488 or vehicleModel == 487 then
				triggerClientEvent(thePlayer, "job:photo:heli", thePlayer)
			end
		end
	end
end
addCommandHandler("photoheli", photoHeli)