local rosie = createPed(275, 1165.6962, -1316.7490, 13.5687)
local lsesOptionMenu = nil
setPedRotation(rosie, 267)
setElementFrozen(rosie, true)
setElementDimension(rosie, 2)
setElementInterior(rosie, 15)
--setPedAnimation(rosie, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false)
setElementData(rosie, "talk", 1, false)
setElementData(rosie, "name", "Győrfi Pál", false)

function popupLSESPedMenu()
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if not lsesOptionMenu then
		local width, height = 150, 100
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		lsesOptionMenu = guiCreateWindow(x, y, width, height, "Miben tudunk segíteni?", false)

		bPhotos = guiCreateButton(0.05, 0.2, 0.87, 0.2, "Segítség", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bPhotos, helpButtonFunction, false)

		bAdvert = guiCreateButton(0.05, 0.5, 0.87, 0.2, "Kinevezés", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bAdvert, appointmentButtonFunction, false)
		
		bSomethingElse = guiCreateButton(0.05, 0.8, 0.87, 0.2, "Nem kell segiteni.", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bSomethingElse, otherButtonFunction, false)
		triggerServerEvent("lses:ped:start", getLocalPlayer(), getElementData(rosie, "name"))
		showCursor(true)
	end
end
addEvent("lses:popupPedMenu", true)
addEventHandler("lses:popupPedMenu", getRootElement(), popupLSESPedMenu)

function closeLSESPedMenu()
	destroyElement(lsesOptionMenu)
	lsesOptionMenu = nil
	showCursor(false)
end

function helpButtonFunction()
	closeLSESPedMenu()
	triggerServerEvent("lses:ped:help", getLocalPlayer(), getElementData(rosie, "name"))
end

function appointmentButtonFunction()
	closeLSESPedMenu()
	triggerServerEvent("lses:ped:appointment", getLocalPlayer(), getElementData(rosie, "name"))
end

function otherButtonFunction()
	closeLSESPedMenu()
end