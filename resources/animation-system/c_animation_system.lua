local anim = false
local localPlayer = getLocalPlayer()
local walkanims = { WALK_armed = true, WALK_civi = true, WALK_csaw = true, Walk_DoorPartial = true, WALK_drunk = true, WALK_fat = true, WALK_fatold = true, WALK_gang1 = true, WALK_gang2 = true, WALK_old = true, WALK_player = true, WALK_rocket = true, WALK_shuffle = true, Walk_Wuzi = true, woman_run = true, WOMAN_runbusy = true, WOMAN_runfatold = true, woman_runpanic = true, WOMAN_runsexy = true, WOMAN_walkbusy = true, WOMAN_walkfatold = true, WOMAN_walknorm = true, WOMAN_walkold = true, WOMAN_walkpro = true, WOMAN_walksexy = true, WOMAN_walkshop = true, run_1armed = true, run_armed = true, run_civi = true, run_csaw = true, run_fat = true, run_fatold = true, run_gang1 = true, run_old = true, run_player = true, run_rocket = true, Run_Wuzi = true }
local attachedRotation = false

function onRender()
	local forcedanimation = getElementData(localPlayer, "forcedanimation")

	if (getPedAnimation(localPlayer)) and not (forcedanimation==1) then
		local screenWidth, screenHeight = guiGetScreenSize()
		anim = true
		local text = "Nyomd meg a Space-t az animáció kilépéshez" .. ( getElementData(localPlayer, "parachuting") and "Parachuting" or "Animation" )
		local width = getElementData(localPlayer, "parachuting") and 435 or 420
		dxDrawText(text, screenWidth-width, screenHeight-91, screenWidth, screenHeight, tocolor ( 0, 0, 0, 255 ), 1, "pricedown")
		dxDrawText(text, screenWidth-width-2, screenHeight-93, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
		
		-- turning while walking
		local block, style = getPedAnimation(localPlayer)
		if block == "ped" and walkanims[ style ] then
			local px, py, pz, lx, ly, lz = getCameraMatrix()
			setPedRotation( localPlayer, math.deg( math.atan2( ly - py, lx - px ) ) - 90 )
		end
	elseif not (getPedAnimation(localPlayer)) and (anim) then
		anim = false
		toggleAllControls(true, true, false)
		triggerEvent("onClientPlayerWeaponCheck", localPlayer)
	end
	
	local element = getElementAttachedTo(localPlayer)
	if element and getElementType( element ) == "vehicle" then
		if attachedRotation then
			local rx, ry, rz = getElementRotation( element )
			setPedRotation( localPlayer, rz + attachedRotation )
		else
			local rx, ry, rz = getElementRotation( element )
			attachedRotation = getPedRotation( localPlayer ) - rz
		end
	elseif attachedRotation then
		attachedRotation = false
	end
end
addEventHandler("onClientRender", getRootElement(), onRender)


local myCommandsWindow = nil
local sourcePlayer = getLocalPlayer()

function commandsHelp()
	local loggedIn = getElementData(sourcePlayer, "loggedin")
	if (loggedIn == 1) then
		if (myCommandsWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myCommandsWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Szerver Animációk", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myCommandsWindow)
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Bezár", true, myCommandsWindow) -- close button

			local commands =
			{
				
				{
					name = "Animok1",
					{ "/gugol","Karakteredet tudod vele legugoltatni"},
					{ "/ujraéleszt","Ujraélesztést tudod vele animálni"},
					{ "/gyere","Magad fele integet a karakter"},
					{ "/kézölbe","Ezzel tudod ölebe tenni a kezed"},
					{ "/várni","Ezzel tudod animálni a várakozást"},
					{ "/kézzseb","Ezzel tudod zsebre tenni a kezeid"},
					{ "/hátradöl","Ezzel tudsz hátradölni pl falhoz"},
					{ "/felsziv","Ezzel tudod animálni a felyzivást(pl Drogok)"},
					{ "/pisil","Ezzel tudod animálni a pisilést"},
					{ "/hoki","csak férfiaknak"},
					{ "/segre","Ezzel tudsz a lányok seggére csapni"},
					{ "/szerel","Ezzel tudod animálni a szerelést"},
					{ "/kézfel","Ezzel tudod felrakni a kezed"},
					{ "/taxi","Ezzel tudsz stoppolni"},
					{ "/here","Csak férfiaknak"},
					{ "/sztiprtiz","Ezzel tudsz erotikusan táncolni"},
					{ "/intés","Ezzel tudsz elöre inteni"},
					{ "/ivás","Ezzel tudsz inni"},
					{ "/hanyattfekvés","Ezzel tudsz hanyattfeküdni"},
					{ "/félelem","Ezzel tudod animálni a félelmet"},
					{ "/részvét","Ezzel tudod animálni a részvétet"},
					{ "/sirás","Ezzel tudod animálni a sirást"},
					{ "/betépve","Ez egy jo kis anim:D"},
				},
				{
					name = "Animok2",
					{ "/tánc","Ezzel tudsz táncolni"},
					{ "/epilepszia","Ezzel tudod animálni az epilepszia rohamot"},
					{ "/hányás","Ezzel tudsz hányni"},
					{ "/rap","Ezzel tudsz rapperkedni"},
					{ "/leül","Ezzel tudsz leülni"},
					{ "/cigi","Ezzel tudod animálni a cigarettázást"},
					{ "/hátradölcigi","Ezzel tudsz hátradölve cigizni"},
					{ "/cigi","Ezzel tudod animálni a cigarettázást"},
					{ "/evés","Ezzel tudod animálni a evést"},
					{ "/nevet","Ezzel tudsz nevetni"},
					{ "/indit","Ezzel tudsz versenyt inditani"},
					{ "/fáradt","Ezzel tudsz fulladni"},
					{ "/ölelés","Ezzel tudsz mást megölelni"},
					{ "/ölelés","Ezzel tudsz mást megölelni"},
					{ "/mivan","Ezzel tudsz kötekedni"},
					{ "/fekvés","Ezzel tudsz lefeküdni"},
					{ "/séta","Ezzel tudsz sétálni"},
				}
			}
			
			for _, levelcmds in pairs( commands ) do
				local tab = guiCreateTab( levelcmds.name, tabPanel)
				local list = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab)
				guiGridListAddColumn (list, "Parancs", 0.6)
				guiGridListAddColumn (list, "Magyarázat", 0.45)
				guiGridListAddColumn (list, "", 0.5)
				guiGridListAddColumn (list, "", 0.7)
				for _, command in ipairs( levelcmds ) do
					local row = guiGridListAddRow ( list )
					guiGridListSetItemText ( list, row, 1, command[1], false, false)
					guiGridListSetItemText ( list, row, 2, command[2], false, false)
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myCommandsWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myCommandsWindow = nil
					end
				end
			end, false)

			guiBringToFront (tlBackButton)
			--guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myCommandsWindow)
			if (visible == false) then
				guiSetVisible( myCommandsWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("animlist", commandsHelp)