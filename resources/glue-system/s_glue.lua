	
function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	exports.logs:logMessage("[/GLUE] " .. getElementData(source, "account:username") .. "/".. getPlayerName(source) .." hozzá lett erősítve ehhez a járműhöz: #".. getElementData(vehicle, "dbid") .. "(dbid) - " .. getElementModel(vehicle), 4)
	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ)
	setPedWeaponSlot(source, slot)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",getRootElement(),gluePlayer)

function ungluePlayer()
	detachElements(source)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",getRootElement(),ungluePlayer)

function glueVehicle(attachedTo, x, y, z, rotX, rotY, rotZ)
	attachElements(source, attachedTo, x, y, z, rotX, rotY, rotZ)
end
addEvent("glueVehicle",true)
addEventHandler("glueVehicle",getRootElement(),glueVehicle)
function unglueVehicle()
	detachElements(source)
end
addEvent("unglueVehicle",true)
addEventHandler("unglueVehicle",getRootElement(),unglueVehicle)