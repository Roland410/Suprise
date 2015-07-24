FPSLimit = 60
FPSMax = 1
player = getLocalPlayer()
sWidth,sHeight = guiGetScreenSize()
addEvent("onClientPlayerHUDShown", true)
addEvent("onClientPlayerHUDHidden", true)

function restoreHUD()
setElementData(player, "state.hud", "enabled")
showChat(true)
showPlayerHudComponent("crosshair", true)
showPlayerHudComponent("radar", true)
triggerServerEvent("onPlayerHUDShown", player)
triggerEvent("onClientPlayerHUDShown", player)
end
addEventHandler("onClientResourceStart", resourceRoot, restoreHUD)
	

function hudvisible ( )
	if getElementData(player, "state.hud") == "disabled" then
	return
	end
--Gets some elements
	local hour, mins = getTime ()
	local time = hour+1 .. ":" .. (((mins < 10) and "0"..mins) or mins)
	local moneycount=getPlayerMoney(getLocalPlayer())
	local money=moneycount..' Ft' 
	local stats= '===Információk==='
	local ostats= '===OOC adatok==='
	local phealth = math.floor (getElementHealth ( getLocalPlayer() ))
	local armor = math.floor(getPedArmor ( getLocalPlayer() ))
	local zone = getZoneName (getElementPosition(getLocalPlayer()))
	local oxygen = getPedOxygenLevel (getLocalPlayer())
	local ammo = getPedTotalAmmo (getLocalPlayer())
	local clip = getPedAmmoInClip (getLocalPlayer())
	local ExP = getElementData(localPlayer,"ExP")
	local Level = getElementData(localPlayer,"Level")
	local rep = getElementData(getLocalPlayer(), "reputation.reputation")
	local reputation = getElementData(getLocalPlayer(), "reputation.status")
	local nev = getPlayerName ( localPlayer )
	local bank=getElementData(localPlayer, "bankmoney")
	--local telszam = tostring(thePhoneNumber)
	local ts= 'flymta.eu'
	local web= 'www.flymta.eu'

--Draws the player hud
	dxDrawText(tostring "Pontos idő: #0000FF" ..time,(0.780)*sWidth, (0.007)*sHeight, (0.293)*sWidth, (0.263)*sHeight,tocolor(0, 0, 0,200),(0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tostring "Pénz: #048907" ..money, (0.780)*sWidth, (0.130)*sHeight, (0.282)*sWidth, (0.326)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring (stats), (0.780)*sWidth, (0.230)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (250, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring "Név: #0000FF"..nev, (0.780)*sWidth, (0.270)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring "Pénz: #048907" ..money, (0.780)*sWidth, (0.310)*sHeight, (0.282)*sWidth, (0.326)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring "Bank: #0000FF" ..bank.. " Ft", (0.780)*sWidth, (0.350)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	
	--dxDrawText(tostring "Név: #0000FF"..nev, (0.780)*sWidth, (0.100)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tostring "Bank: #0000FF" ..bank, (0.780)*sWidth, (0.160)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tostring "#999999" ..armor.."%", (0.880)*sWidth, (0.1)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tostring "#bf0000" ..phealth.."%", (0.880)*sWidth, (0.170)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tostring "Telefonszám: #0000FF" ..telszam, (0.780)*sWidth, (0.160)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring (ostats), (0.780)*sWidth, (0.390)*sHeight, (5.293)*sWidth, (0.350)*sHeight, tocolor (250, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring "TS3: #0fff00"..ts, (0.780)*sWidth, (0.430)*sHeight, (5.293)*sWidth, (0.326)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(tostring "Web: #ffb400"..web, (0.780)*sWidth, (0.470)*sHeight, (5.293)*sWidth, (5.263)*sHeight, tocolor (0, 0, 0, 255), (0.8/1366)*sWidth,(0.8/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	

	--dxDrawText("Level: #FF9600"..Level, (400/1024)*sWidth, (745/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText("Reputation: #00FF00"..ExP, (575/1024)*sWidth, (745/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText("Health: #FF0000"..phealth.."%", (875/1024)*sWidth, (50/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (0, 0, 0, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText("Armor: #0000FF"..armor.."%", (882/1024)*sWidth, (70/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (0, 0, 0, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	dxDrawText(zone, (750/1024)*sWidth, (745/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.foot")).." m", (25/1024)*sWidth, (200/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.Automobile")).." m", (25/1024)*sWidth, (215/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.Plane")).." m", (25/1024)*sWidth, (230/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.Bike")).." m", (25/1024)*sWidth, (245/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.Helicopter")).." m", (25/1024)*sWidth, (260/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.BMX")).." m", (25/1024)*sWidth, (275/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--dxDrawText(tonumber(getElementData(getLocalPlayer(), "distance.Quad")).." m", (25/1024)*sWidth, (290/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	
	--if rep then
	--dxDrawText("Reputation: "..level, (575/1024)*sWidth, (745/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--end
	--if reputation and fileExists ( ":reputation/reputation/goodevil_"..reputation..".png" ) then
	--size = dxGetFontHeight((0.7/1366)*sWidth, "bankgothic")
	--dxDrawImage((557/1024)*sWidth, (745/768)*sHeight, size, size, ":reputation/reputation/goodevil_"..reputation..".png")
	--end
	
	--if  oxygen < 1000 or isElementInWater(getLocalPlayer()) then
	--dxDrawText("Oxygen: #00FFFF"..math.floor(oxygen/10).."%", (874/1024)*sWidth, (90/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (0, 0, 0, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--end
	
	--if getControlState ("aim_weapon") or isPedDoingGangDriveby(getLocalPlayer()) then
	--local xb,yb,zb = getPedBonePosition(getLocalPlayer(), 8)
	--local zb = zb + 0.5
	--local xs,ys = getScreenFromWorldPosition ( xb,yb,zb )
	--	if xs and ys then
		--dxDrawText(clip.."/"..ammo, xs,ys, (289/1024)*sWidth, (250/768)*sHeight, tocolor (255, 255, 255, 255), (0.7/1366)*sWidth,(0.7/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	--	end
	--end
	
	
	


--Gets the vehicle & checks if is the ped in a vehicle (for evade the debug spam with bad arguments when someone is on foot)
	--vehicle = getPedOccupiedVehicle(getLocalPlayer())
	--if ( vehicle ) then --checking
	--	-- Gets some vehicle elements (gear, speed in MPH and KMH and health)
	--	speedx, speedy, speedz = getElementVelocity ( vehicle  )
	--	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	--	kmh = math.floor(actualspeed*180) -- Kilometers per hour
	--	mph = math.floor(actualspeed * 111.847) -- Milles per hour
	--	mps = math.floor (actualspeed) -- Metres per second
		
	--	if getElementHealth(vehicle) >= 999 then
	--	vehiclehealth = 100
	--	else
	--	vehiclehealth = math.floor(getElementHealth ( vehicle )/10)
--		end
--
--		dxDrawText("km/h: "..kmh, (900/1024)*sWidth, (675/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (0, 0, 0, 255), (0.85/1366)*sWidth,(0.85/768)*sHeight,"bankgothic","left","top",false,false,false,true)
--		dxDrawText("Health: #FF0000"..vehiclehealth.."%", (871/1024)*sWidth, (700/768)*sHeight, (289/1024)*sWidth, (250/768)*sHeight, tocolor (0, 0, 0, 255), (0.85/1366)*sWidth,(0.6/768)*sHeight,"bankgothic","left","top",false,false,false,true)
--	end
end 
addEventHandler ("onClientRender", root, hudvisible )


--This will disable original hud
function hideall(player)
	showPlayerHudComponent ( "ammo", true )
	showPlayerHudComponent ( "area_name", false )
	showPlayerHudComponent ( "armour", true )
	showPlayerHudComponent ( "breath", false )
	showPlayerHudComponent ( "clock", false )
	showPlayerHudComponent ( "health", true )
	showPlayerHudComponent ( "money", false )
	showPlayerHudComponent ( "vehicle_name", false )
	showPlayerHudComponent ( "weapon", true )
end
addEventHandler ( "onClientResourceStart", getRootElement(), hideall )

function showall(player)
	showPlayerHudComponent ( "ammo", false )
	showPlayerHudComponent ( "area_name", true )
	showPlayerHudComponent ( "armour", false )
	showPlayerHudComponent ( "breath", true )
	showPlayerHudComponent ( "clock", true )
	showPlayerHudComponent ( "health", false )
	showPlayerHudComponent ( "money", false )
	showPlayerHudComponent ( "vehicle_name", true )
	showPlayerHudComponent ( "weapon", false )
end
addEventHandler ( "onClientResourceStop", resourceRoot, showall )



function onClientResourceStart ( resource )
	if ( guiFPSLabel == nil ) then
		FPSLimit = 255 / FPSLimit
		FPSCalc = 0
		FPSTime = getTickCount() + 1000
		addEventHandler ( "onClientRender", getRootElement (), onClientRender )
	end
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), onClientResourceStart )

function onClientRender ( )
	if getElementData(player, "state.hud") == "disabled" then
	return
	end
	if getElementData(localPlayer, "hud.ping") then
	dxDrawText("PING: "..getElementData(localPlayer, "hud.ping"), (8/1024)*sWidth, (695/768)*sHeight, (130/1024)*sWidth, (130/768)*sHeight, tocolor (255, 255, 255, 255), (0.4/1366)*sWidth,(0.4/768)*sHeight,"bankgothic","left","top",false,false,false,true)
	end
	if ( getTickCount() < FPSTime ) then
		FPSCalc = FPSCalc + 1
	else
		if ( FPSCalc > FPSMax ) then FPSLimit = 255 / FPSCalc FPSMax = FPSCalc end
		setElementData(player, "FPS", FPSCalc)
		FPSCalc = 0
		FPSTime = getTickCount() + 1000
	end
dxDrawText("FPS: "..getElementData(getLocalPlayer(), "FPS"), (8/1024)*sWidth, (680/768)*sHeight, (130/1024)*sWidth, (130/768)*sHeight, tocolor (255, 255, 255, 255), (0.4/1366)*sWidth,(0.4/768)*sHeight,"bankgothic","left","top",false,false,false,true)
end

function refreshHUDPing()
setElementData(localPlayer, "hud.ping", getPlayerPing(localPlayer))
end
setTimer(refreshHUDPing, 1000, 0)

function showOnlineStaff(moderators,admins)
moderatorText = "Moderators: "
adminText = "Admins: "
	for k,moderator in ipairs(moderators) do
	local name = getPlayerName(moderator):gsub("#%x%x%x%x%x%x","")
		if k == 1 then
		moderatorText = moderatorText..""..name
		else
		moderatorText = moderatorText..", "..name
		end
	end
	for k,admin in ipairs(admins) do
	local name = getPlayerName(admin):gsub("#%x%x%x%x%x%x","")
		if k == 1 then
		adminText = adminText..""..name
		else
		adminText = adminText..", "..name
		end
	end
end
addEvent("onClientStaffRefresh", true)
addEventHandler("onClientStaffRefresh", getRootElement(), showOnlineStaff)

function showStaffMembers()
	if getElementData(player, "state.hud") == "disabled" then
	return
	end
	if moderatorText then
	dxDrawText(moderatorText, (8/1024)*sWidth, (730/768)*sHeight, (130/1024)*sWidth, (130/768)*sHeight, tocolor (255, 255, 255, 255), (0.4/1366)*sWidth,(0.4/768)*sHeight,"bankgothic","left","top",false,false,false,false)
	end
	if adminText then
	dxDrawText(adminText, (8/1024)*sWidth, (745/768)*sHeight, (130/1024)*sWidth, (130/768)*sHeight, tocolor (255, 255, 255, 255), (0.4/1366)*sWidth,(0.4/768)*sHeight,"bankgothic","left","top",false,false,false,false)
	end
end
addEventHandler("onClientRender", getRootElement(), showStaffMembers)

function hidePlayerHUD()
local player = getLocalPlayer()
	if getElementData(player, "state.hud") == "disabled" then
	setElementData(player, "state.hud", "enabled")
	showChat(true)
	showPlayerHudComponent("crosshair", true)
	showPlayerHudComponent("radar", true)
	triggerServerEvent("onPlayerHUDShown", player)
	triggerEvent("onClientPlayerHUDShown", player)
	else
	setElementData(player, "state.hud", "disabled")
	showChat(false)
	showPlayerHudComponent("crosshair", false)
	showPlayerHudComponent("radar", false)
	triggerServerEvent("onPlayerHUDHidden", player)
	triggerEvent("onClientPlayerHUDHidden", player)
	end
end

addEventHandler("onClientPlayerSpawn", getLocalPlayer(), 
	function ()
		if getElementData(source, "state.hud") == "disabled" then
		setTimer(showChat, 50, 1, false)
		end
	end)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
	bindKey("F5", "down", hidePlayerHUD)
	end)
	
addEventHandler("onClientPlayerQuit", getLocalPlayer(),
	function()
	unbindKey("F5", "down", hidePlayerHUD)
	end)

