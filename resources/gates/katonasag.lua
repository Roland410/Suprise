local objGateg = createObject(980, -489.5, -561.29998779297, 27.299999237061, -0.13600, 0, 180)
exports.pool:allocateElement(objGateg)

--createObject(980, -489.5, -561.29998779297, 27.299999237061, -0.13600, 0, 180)



local open = false

-- Gate code
function usePDFrontGarageGate(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(-489.5, -561.29998779297, 27.299999237061, x, y, z)
		
	if (distance<=10) and (open==false) then
		if (exports.global:hasItem(thePlayer, 149)) then
			open = true
			outputChatBox(" kapu nyitva!", thePlayer, 0, 255, 0)
			moveObject(objGateg, 1000, -489.5, -561.29998779297, 20.299999237061, 0, 0, 0)
			setTimer(closePDFrontGarageGate, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("nyit", usePDFrontGarageGate)

function closePDFrontGarageGate(thePlayer)
	setTimer(resetState8, 1000, 1)
	moveObject(objGateg, 1000, -489.5, -561.29998779297, 27.299999237061, 0, 0, 0)
end

function resetState8()
	open = false
end