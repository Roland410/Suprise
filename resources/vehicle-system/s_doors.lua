function controlVehicleDoor(door, position)

	if not (isElement(source)) then
		return
	end
	
	if (isVehicleLocked(source)) then
		return
	end
	
	vehicle1x, vehicle1y, vehicle1z = getElementPosition ( source )
	player1x, player1y, player1z = getElementPosition ( client )
	if not (getPedOccupiedVehicle ( client ) == source) and not (getDistanceBetweenPoints2D ( vehicle1x, vehicle1y, player1x, player1y ) < 5) then
		return
	end
	
	local ratio = position/100
	if position == 0 then
		ratio = 0
	elseif position == 100 then
		ratio = 1
	end
	setVehicleDoorOpenRatio(source, door, ratio, 0.5)
end		
addEvent("vehicle:control:doors", true)
addEventHandler("vehicle:control:doors", getRootElement(), controlVehicleDoor)

function controlRamp(theVehicle)
	local playerVehicle = getPedOccupiedVehicle(client)
	
	if not (isElement(theVehicle) and theVehicle == playerVehicle) then
		outputChatBox("A járműben kell lenned hogy ezt használd.", client, 255, 0, 0)
		return
	end
	
	if not (exports['item-system']:hasItem(theVehicle, 117)) then
		outputChatBox("Szükséged van a tárgyra is a kocsiban hogy ezt használd!", client, 255, 0, 0)
		return
	end

	if not (getElementData(theVehicle, "handbrake") == 1) or not isElementFrozen(theVehicle) then
		outputChatBox("Először be kell húznod a kéziféket hogy használd a rámpát!", client, 255, 0, 0)
		return
	end
	
	if not (getElementModel(theVehicle) == 578) then
		outputChatBox("Ez a jármű nem kompatibilis ezzel a rámpával!", client, 255, 0, 0)
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if not (rampObject) or not (isElement(rampObject)) then
		if (getElementModel(theVehicle) == 578) then
			local vehiclePositionX, vehiclePositionY, vehiclePositionZ = getElementPosition(theVehicle)
			local vehicleRotationX, vehicleRotationY, vehicleRotationZ = getElementRotation(theVehicle)
		
			rampObject = createObject(5152, vehiclePositionX + 0.1, vehiclePositionY - 7.65, vehiclePositionZ  - 1.3, vehicleRotationX, vehicleRotationY, vehicleRotationZ + 90) 
			attachElements( rampObject, theVehicle, 0.1, -7.65, -1.3, 0, 0, 90) 
			setElementPosition(theVehicle, getElementPosition(theVehicle))
			exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", rampObject, false)
		end
	else
		destroyElement(rampObject)
		exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEvent("vehicle:control:ramp", true)
addEventHandler("vehicle:control:ramp", getRootElement(), controlRamp)

function checkRamp(sourcePlayer)
	local theVehicle = source
	if not (isElement(theVehicle)) then
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if rampObject then
		destroyElement(rampObject)
		exports['anticheat-system']:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEventHandler("vehicle:handbrake:lifted", getRootElement(), checkRamp)