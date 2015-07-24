local odimension, ointerior, ox, oy, oz, orot, oskin
local localPlayer = getLocalPlayer()
local team = 0
local factionrank
local skins
local skincount
local curr

function changeDutySkin()
	local factionid = getElementData(localPlayer, "faction")
	factionrank = getElementData(localPlayer, "factionrank")
	curr = 1
	if (factionid == 1) then ---//SCPD
		team = 1
		skins = {71,288,280,281,282,265,284,60,283}
		
		skins[1] = { }
		skins[1][1] = 71
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 288
		skins[2][2] = 2
		
		skins[3] = { }
		skins[3][1] = 280
		skins[3][2] = 10
		
		skins[4] = { }
		skins[4][1] = 281
		skins[4][2] = 12
		
		skins[5] = { }
		skins[5][1] = 282
		skins[5][2] = 15
		
		skins[6] = { }
		skins[6][1] = 265
		skins[6][2] = 2
		
		skins[7] = { }
		skins[7][1] = 284
		skins[7][2] = 13
		
		skins[8] = { }
		skins[8][1] = 281
		skins[8][2] = 13
		
		skins[9] = { }
		skins[9][1] = 60
		skins[9][2] = 13
		
		skins[10] = { }
		skins[10][1] = 283
		skins[10][2] = 13
		
		skincount = 10
	elseif (factionid==18) then ---//FBI
		team = 2
		skins = {163,164,165,166}
		
		skins[1] = { }
		skins[1][1] = 163
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 164
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 165
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 166
		skins[4][2] = 1
		
		skins[5] = { }
		skins[5][1] = 286
		skins[5][2] = 1
			
		
		skincount = 5
	elseif (factionid==7) then ---//Ballas
		team = 7
		skins = {102,103,104,20,7,182}
		
		skins[1] = { }
		skins[1][1] = 102
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 103
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 104
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 20
		skins[4][2] = 1
		
		skins[5] = { }
		skins[5][1] = 7
		skins[5][2] = 1

		
		skins[6] = { }
		skins[6][1] = 182
		skins[6][2] = 1		
		
		skincount = 6
	elseif (factionid==2) then ---//SCMD
		team = 2
		skins = {274,70}
		
		skins[1] = { }
		skins[1][1] = 274
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 70
		skins[2][2] = 1
		
		skincount = 2
		
		
	elseif (factionid==3) then ---//Önkori
		team = 3
		skins = {147, 17, 228,}
		
		skins[1] = { }
		skins[1][1] = 147
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 17
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 228
		skins[3][2] = 1

	

		skincount = 3
	elseif (factionid==9) then ---//Los Santos Vagos
		team = 9
		skins = {108, 109, 110, 30}
		
		skins[1] = {}
		skins[1][1] = 108
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 109
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 110
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 30
		skins[4][2] = 1
		
		skincount = 4
	elseif (factionid==17) then ---//Groove
		team = 17
		skins = {270,269,271,195,107,106,105}
		
		skins[1] = {}
		skins[1][1] = 270
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 269
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 271
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 195
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 107
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 106
		skins[6][2] = 1
		
		skins[7] = { }
		skins[7][1] = 105
		skins[7][2] = 1
		
		
		skincount = 7	
	elseif (factionid==4) then ---//Ukrayenksa Mafia
		team = 4
		skins = {126,125,127,259,157,203,96}
		
		skins[1] = {}
		skins[1][1] = 126
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 125
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 127
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 259
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 157
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 203
		skins[6][2] = 1
		
		skins[7] = { }
		skins[7][1] = 96
		skins[7][2] = 1
		
		skincount = 7
	elseif (factionid==5) then ---//Jokas Mafia
		team = 5
		skins = {112,113,159,160,57,94,97}
		
		skins[1] = {}
		skins[1][1] = 112
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 113
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 159
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 160
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 57
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 94
		skins[6][2] = 1
		
		skins[7] = { }
		skins[7][1] = 97
		skins[7][2] = 1
		
		skincount = 7
	elseif (factionid==6) then ---//Riporterek
		team = 6
		skins = {20}
		
		skins[1] = {}
		skins[1][1] = 20
		skins[1][2] = 1
			
		skincount = 1
		
	elseif (factionid==8) then ---//Tüzoltóság
		team = 8
		skins = {277,278,279}
		
		skins[1] = {}
		skins[1][1] = 277
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 278
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 279
		skins[3][2] = 1
			
		skincount = 3
		
	elseif (factionid==10) then ---//Camorra
		team = 10
		skins = {46, 223, 241, 242, 240, 32, 199, 124, 158, 202, 58, 95,}
		
		skins[1] = {}
		skins[1][1] = 46
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 223
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 241
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 242
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 240
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 32
		skins[6][2] = 1
		
		skins[7] = { }
		skins[7][1] = 199
		skins[7][2] = 1
		
		skins[8] = { }
		skins[8][1] = 124
		skins[8][2] = 1
		
		skins[9] = { }
		skins[9][1] = 158
		skins[9][2] = 1

		skins[10] = { }
		skins[10][1] = 202
		skins[10][2] = 1
		
		skins[11] = { }
		skins[11][1] = 58
		skins[11][2] = 1
		
		skins[12] = { }
		skins[12][1] = 95
		skins[12][2] = 1

		
		skincount = 12
		
	elseif (factionid==11) then ---//Parkolás felügyelet
		team = 11
		skins = {50,71}
		
		skins[1] = {}
		skins[1][1] = 50
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 71
		skins[2][2] = 1
			
		skincount = 2	
		
		elseif (factionid==12) then ---//Yakuza
		team = 12
		skins = {120,186,229,123,122,121,117,220,132,156}
		
		skins[1] = {}
		skins[1][1] = 121
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 122
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 123
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 229
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 117
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 220
		skins[6][2] = 1

		skins[7] = { }
		skins[7][1] = 132
		skins[7][2] = 1

		skins[8] = { }
		skins[8][1] = 156
		skins[8][2] = 1

		skins[9] = { }
		skins[9][1] = 186
		skins[9][2] = 1		
		
		skins[10] = { }
		skins[10][1] = 120
		skins[10][2] = 1				
		
		skincount = 10
			

		elseif (factionid==13) then ---//Surenos
		team = 13
		skins = {298,292,41,173,174,175,184,114,115,116,48}
		
		skins[1] = {}
		skins[1][1] = 298
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 292
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 41
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 184
		skins[4][2] = 1
		
		skins[5] = {}
		skins[5][1] = 114
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 115
		skins[6][2] = 1

		skins[7] = { }
		skins[7][1] = 116
		skins[7][2] = 1

		skins[8] = { }
		skins[8][1] = 48
		skins[8][2] = 1

		skins[9] = { }
		skins[9][1] = 175
		skins[9][2] = 1		
		
		skins[10] = { }
		skins[10][1] = 174
		skins[10][2] = 1		

		skins[11] = { }
		skins[11][1] = 173
		skins[11][2] = 1			
		
		skincount = 11
						
	
	elseif (factionid==20) then ---//NAV
		team = 20
		skins = {71, 280, 288}
		
		skins[1] = {}
		skins[1][1] = 71
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 280
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 288
		skins[3][2] = 1
		
		skincount = 3	
	else	
		return outputChatBox("Nem találtam meg a listában a frakciót!",255, 0, 0)
	end
	
	odimension = getElementDimension(localPlayer)
	ointerior = getElementInterior(localPlayer)
	ox, oy, oz = getElementPosition(localPlayer)
	orot = getPedRotation(localPlayer)
	oskin = getElementModel(localPlayer)
	
	local dimension = 65000 + getElementData(localPlayer, "gameaccountid")
	setElementDimension(localPlayer, dimension)
	setElementInterior(localPlayer, 0)
	setElementPosition(localPlayer, 2373.1181640625, 972.830078125, 18.318904876709)
	setPedRotation(localPlayer, 0)
	
	setCameraMatrix(2373.0029296875, 976.880859375, 18.318904876709, 2373.1181640625, 972.830078125, 18.318904876709)
	bindKey("Enter", "down", finishDutySkin)
	addEventHandler("onClientRender", getRootElement(), displayHelpText)
	
	unbindKey("F4", "down", changeDutySkin)
	bindKey("arrow_l", "down", prevDutySkin)
	bindKey("arrow_r", "down", nextDutySkin)
	
	setElementModel(localPlayer, skins[1][1])
	
	toggleAllControls(false, true, false)
end
bindKey("F4", "down", changeDutySkin)

function prevDutySkin()
	curr = curr - 1
	if (curr<1) then
		curr = skincount
	end
	
	setElementModel(localPlayer, skins[curr][1])
end

function nextDutySkin()
	curr = curr + 1
	if (curr>skincount) then
		curr = 1
	end
	
	setElementModel(localPlayer, skins[curr][1])
end

function displayHelpText()
	local screenWidth, screenHeight = guiGetScreenSize()
	dxDrawText("A nyilakkal válaszd ki a megfelelő egyenruhát és nyomj ENTER-t.", screenHeight-380, screenHeight-93, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	if (skins[curr][2]>factionrank) then
		dxDrawText("Túl alacsony a rangod ehhez az egyenruhához.", screenHeight-380, screenHeight-120, screenWidth-30, screenHeight, tocolor ( 255, 0, 0, 255 ), 1, "pricedown")
	end
end

function finishDutySkin()
	if (skins[curr][2]>factionrank) then
		playSoundFrontEnd(7)
	else
		toggleAllControls(true, true, false)
		bindKey("F4", "down", changeDutySkin)
		unbindKey("arrow_l", "down", prevDutySkin)
		unbindKey("arrow_r", "down", nextDutySkin)
		removeEventHandler("onClientRender", getRootElement(), displayHelpText)
		setElementDimension(localPlayer, odimension)
		setElementInterior(localPlayer, ointerior)
		triggerServerEvent("finishDutySkin", localPlayer, ox, oy, oz, orot, odimension, ointerior, skins[curr][1])
		setElementModel(localPlayer, oskin)
		unbindKey("Enter", "down", finishDutySkin)
	end
end