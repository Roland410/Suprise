local id = 0

local RADIOSZAMA = 1

local radiok =
{
	"http://79.172.241.237:8000/radio1.mp3"
}

sound = nil
function cancel()
	cancelEvent()
end
addEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)

function AllomasValtas(id)
	stopSound ( sound )
	sound = playSound ( radiok[id])
end
function radioNext()
	if not isCursorShowing() then
		id = id + 1
		if id >= RADIOSZAMA then
			id = 0
		end
		removeEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
		AllomasValtas(id)
		addEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
	end
end
addCommandHandler("radionext",radioNext)
bindKey("mouse_wheel_up","down","radionext")

function radioPrev()
	if not isCursorShowing() then
		id = id - 1
		if id <= -1 then
			id = RADIOSZAMA
		end
		removeEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
		AllomasValtas(id)
		addEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
	end
end
addCommandHandler("radioprev",radioPrev)
bindKey("mouse_wheel_down","down","radioprev")

function restoreChannel()
	removeEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
	AllomasValtas(id)
	addEventHandler("onClientPlayerRadioSwitch",getRootElement(),cancel)
end
addEventHandler("onClientPlayerVehicleEnter",getLocalPlayer(),restoreChannel)