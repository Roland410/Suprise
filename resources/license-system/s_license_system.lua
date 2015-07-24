mysql = exports.mysql

function onLicenseServer()
	local gender = getElementData(source, "gender")
	if (gender == 0) then
		exports.global:sendLocalText(source, "Carla Cooper mondja: Üdv uram, jogosítványt szeretne?", nil, nil, nil, 10)
	else
		exports.global:sendLocalText(source, "Carla Cooper mondja: Jó napot hölgyem, jogosítványt szeretne?", nil, nil, nil, 10)
	end
end

addEvent("onLicenseServer", true)
addEventHandler("onLicenseServer", getRootElement(), onLicenseServer)

function giveLicense(license, cost)
	if (license==1) then -- car drivers license
		local theVehicle = getPedOccupiedVehicle(source)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "realinvehicle", 0, false)
		removePedFromVehicle(source)
		respawnVehicle(theVehicle)
		exports['anticheat-system']:changeProtectedElementDataEx(source, "license.car", 1)
		exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "handbrake", 1, false)
		setElementFrozen(theVehicle, true)
		mysql:query_free("UPDATE characters SET car_license='1' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("Gratulálok, sikeresen elvégezted a vizsgát. Megkaptad a jogosítványt.", source, 255, 194, 14)
		outputChatBox("Fizettél 50000Ft-t.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	end
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function payFee(amount)
	exports.global:takeMoney(source, amount)
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function passTheory()
	exports['anticheat-system']:changeProtectedElementDataEx(source,"license.car.cangetin",true, false)
	exports['anticheat-system']:changeProtectedElementDataEx(source,"license.car",3) -- Set data to "theory passed"
	mysql:query_free("UPDATE characters SET car_license='3' WHERE charactername='" .. mysql:escape_string(getPlayerName(source)) .. "' LIMIT 1")
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function showLicenses(thePlayer, commandName, targetPlayer)
	local loggedin = getElementData(thePlayer, "loggedin")

	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("HASZNÁLAT: /" .. commandName .. " [NévRészlet/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("A játékos nincs bejelentkezve.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
						
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
						outputChatBox("Túl messze van '".. targetPlayerName .."'.", thePlayer, 255, 0, 0)
					else
						outputChatBox("Megmutattad az engedélyeidet neki: " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
						outputChatBox(getPlayerName(thePlayer) .. " Megmutatta az engedélyeit neked", targetPlayer, 255, 194, 14)
						
						local gunlicense = getElementData(thePlayer, "license.gun")
						local carlicense = getElementData(thePlayer, "license.car")
						
						local guns, cars
						
						if (gunlicense<=0) then
							guns = "Nincs"
						else
							guns = "Van"
						end
						
						if (carlicense<=0) then
							cars = "Nincs"
						elseif (carlicense==3)then
							cars = "Elméleti vizsga"
						else
							cars = "Van"
						end
						
						outputChatBox("~-~-~-~- " .. getPlayerName(thePlayer) .. " engedélyei -~-~-~-~", targetPlayer, 255, 194, 14)
						outputChatBox("        Fegyvertartási engedély: " .. guns, targetPlayer, 255, 194, 14)
						outputChatBox("        Személyi gépjármű jogosítvány: " .. cars, targetPlayer, 255, 194, 14)
					end
				end
			end
		end
	end
end
addCommandHandler("engedelyem", showLicenses, false, false)


function checkDMVCars(player, seat)
	-- aka civilian previons
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 436 then
		if getElementData(player,"license.car") == 3 then
			if getElementData(player, "license.car.cangetin") then
				outputChatBox("(( A 'J' betűvel indítod el a járművet és a kéziféket a '/handbrake' paranccsal kezelheted. ))", player, 0, 255, 0)
			else
				outputChatBox("(( Ez az Autósiskola járműve, csak vizsgára használható. Keresd fel kérlek Carla Coopert. ))", player, 255, 0, 0)
				cancelEvent()
			end
		elseif seat > 0 then
			outputChatBox("(( Ez az Autósiskola járműve, csak vizsgára használható. ))", player, 255, 194, 14)
		else
			outputChatBox("(( Ez az Autósiskola járműve, csak vizsgára használható. ))", player, 255, 0, 0)
			cancelEvent()
		end
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)