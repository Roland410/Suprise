toggleNews = true

function ZeneStop()
	stopSound (loginzene)
end
addEventHandler("accounts:characters:spawn", getRootElement(), ZeneStop)

function ZeneStart()
		loginzene = playSound( "zene.mp3", true)
end
addEventHandler("accounts:login:request", getRootElement(), ZeneStart)



local screenX, screenY = guiGetScreenSize()
addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		setElementDimension ( getLocalPlayer(), 1 )
		setElementInterior( getLocalPlayer(), 0 )
		setCameraMatrix( 1055.4643554688, -2122.0646972656, 83.747100830078, 1054.6900634766, -2121.4748535156, 83.517967224121)
		setCloudsEnabled(false)
		fadeCamera(true)
		guiSetInputEnabled(true)
		clearChat()
		LoginScreen_openLoginScreen()
	end
);

local wLogin, lUsername, tUsername, lInfo, lPassword, tPassword, chkRememberLogin, bLogin, bRegister, bTour, updateTimer = nil
function LoginScreen_openLoginScreen()
		local scr = {guiGetScreenSize() }
		local w, h = 700, 450
		local x, y = (scr[1]/2)-(w/2), (scr[2]/2)-(h/2)
		
		
	--- New Account Panel! - Made By TNT|NikeHD -
	
	wLogin = guiCreateStaticImage(426,221,425,308,"gui/kep.png",false)
	
	-- Login Button.
	bLogin = guiCreateButton(148,227,123,33,"",false,wLogin)
	guiSetFont(bLogin, "default-bold-small")
	addEventHandler("onClientGUIClick", bLogin, LoginScreen_validateLogin,false)
	guiSetAlpha(bLogin,0.2)
	-- Username Memo.
	tUsername = guiCreateEdit(112,110,195,34, "Felhasználónév", false, wLogin)
	guiSetFont(tUsername, "default-bold-small")
	guiEditSetMaxLength(tUsername, 32)
	addEventHandler("onClientGUIAccepted", tUsername,LoginScreen_validateLogin,false)
	guiSetAlpha(tUsername,0.2)
	-- Password Memo.
	tPassword = guiCreateEdit(112,183,195,34, "Jelszó", false, wLogin)
	guiSetFont(tPassword, "default-bold-small")
	guiEditSetMasked(tPassword,true)
	guiEditSetMaxLength(tPassword,64)
	addEventHandler("onClientGUIAccepted", tPassword,LoginScreen_validateLogin,false)
	guiSetAlpha(tPassword,0.2)
	-- Remember me Check Box.
	chkRememberLogin = guiCreateCheckBox(143,248,67,22,"",false,false,wLogin)
	guiSetText(tUsername, tostring( loadSavedData("username", "") ))
	local tHash = tostring( loadSavedData("hashcode", "") )
	guiSetText(tPassword,  tHash)
	if #tHash > 1 then
		guiCheckBoxSetSelected(chkRememberLogin, true)
	end
	addEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
--	updateTimer = setTimer(LoginScreen_RefreshIMG, 7500, 0)
	triggerEvent("accounts:options:settings:updated", getLocalPlayer())
end


function LoginScreen_startRegister()
	LoginScreen_showWarningMessage( "Regisztrálni az\nhttp://ucp.flymta.eu\noldalon tudsz!" )
end

function LoginScreen_closeLoginScreen()
	destroyElement(lUsername)
	destroyElement(tUsername)
	destroyElement(lPassword)
	destroyElement(tPassword)
	destroyElement(chkRememberLogin)
	destroyElement(bLogin)
	destroyElement(bRegister)
	destroyElement(bTour)
	destroyElement(wLogin)
--	destroyElement(thelogo)
--	killTimer(updateTimer)
	removeEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
	removeEventHandler( "onClientRender", root, togNews )
end

function LoginScreen_validateLogin()
	local username = guiGetText(tUsername)
	local password = guiGetText(tPassword)
	
	guiSetText(tPassword, "")
	appendSavedData("hashcode", "")
	if (string.len(username)<3) then
		outputChatBox("A megadott név túl rövid! (minimum 3 karakter).", 255, 0, 0)
	else
		local saveInfo = guiCheckBoxGetSelected(chkRememberLogin)
		triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, saveInfo) 
						
		if (saveInfo) then
			appendSavedData("username", tostring(username))
		else
			appendSavedData("username", "")
		end
			
	end	
end

local warningBox, warningMessage, warningOk = nil
function LoginScreen_showWarningMessage( message )

	if (isElement(warningBox)) then
		destroyElement(warningBox)
	end
	
	local x, y = guiGetScreenSize()
	warningBox = guiCreateWindow( x*.5-150, y*.5-65, 300, 120, "Figyelem!", false )
	guiWindowSetSizable( warningBox, false )
	warningMessage = guiCreateLabel( 40, 30, 220, 60, message, false, warningBox )
	guiLabelSetHorizontalAlign( warningMessage, "center", true )
	guiLabelSetVerticalAlign( warningMessage, "center" )
	warningOk = guiCreateButton( 130, 90, 70, 20, "Ok", false, warningBox )
	addEventHandler( "onClientGUIClick", warningOk, function() destroyElement(warningBox) end )
	guiBringToFront( warningBox )
end

addEventHandler("accounts:login:attempt", getRootElement(), 
	function (statusCode, additionalData)
		
		if (statusCode == 0) then
			LoginScreen_closeLoginScreen()
			
			if (isElement(warningBox)) then
				destroyElement(warningBox)
			end
			
			for _, theValue in ipairs(additionalData) do
				setElementData(getLocalPlayer(), theValue[1], theValue[2], false)
			end
			
			local newAccountHash = getElementData(getLocalPlayer(), "account:newAccountHash")
			appendSavedData("hashcode", newAccountHash or "")
			
			local characterList = getElementData(getLocalPlayer(), "account:characters")
			
			if #characterList == 0 then
				newCharacter_init()
			else
				Characters_showSelection()
			end
			
		elseif (statusCode > 0) and (statusCode < 5) then
			LoginScreen_showWarningMessage( additionalData )
		elseif (statusCode == 5) then
			LoginScreen_showWarningMessage( additionalData )
		end
	end
)

function LoginScreen_RunFX()
		local scr = {guiGetScreenSize() }
		local w, h = 562, 108
		local x, y = (scr[1]/2)-(w/2), (scr[2]/5)-(h/2)
	
	dxDrawRectangle(0, 0, screenX, screenY, tocolor(0, 0, 0, 150), false)
	--thelogo = dxDrawImage(x,y,w,h, "img/image1.png", 0, 0, 0, tocolor(255, 255, 255, 255))
end

function serverTour( show )
	if show then
		destroyElement(lUsername)
		destroyElement(tUsername)
		destroyElement(lPassword)
		destroyElement(tPassword)
		destroyElement(chkRememberLogin)
		destroyElement(bLogin)
		destroyElement(bRegister)
		destroyElement(bTour)
		destroyElement(wLogin)
		destroyElement(thelogo)
		killTimer(updateTimer)
		removeEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
		removeEventHandler( "onClientRender", root, togNews )

		showCursor( true )
		
		createMenu( help_menu )
		
	else
		destroyMenu( )
		destroyElement(lUsername)
		destroyElement(tUsername)
		destroyElement(lPassword)
		destroyElement(tPassword)
		destroyElement(chkRememberLogin)
		destroyElement(bLogin)
		destroyElement(bRegister)
		destroyElement(bTour)
		destroyElement(wLogin)
		destroyElement(thelogo)
		killTimer(updateTimer)
		removeEventHandler( "onClientRender", getRootElement(), LoginScreen_RunFX )
		removeEventHandler( "onClientRender", root, togNews )
		if cameraupdatetimer then
			killTimer( cameraupdatetimer )
			cameraupdatetimer = nil
			
			fadeCamera( true )
		end
	end
end

function togNews()
	local screenX, screenY = guiGetScreenSize()
	--dxDrawText("Frissités... ", screenX / 2 + 160, screenY / 2 - 180, screenX / 2 + 550, 300, tocolor(255, 255, 255, 255), 1.5, "default-bold", "left", "top",false, true)
	--dxDrawText(getElementData(resourceRoot, "news:title") or "Unable to receive the news!", screenX / 2 + 160, screenY / 2 - 140, screenX / 2 + 550, 300, tocolor(255, 255, 255, 255), 1, "default-bold", "left", "top",false, true)
	--dxDrawText(getElementData(resourceRoot, "news:sub") or "Error - JQ142", screenX / 2 + 160, screenY / 2 - 110, screenX / 2 + 550, 300, tocolor(255, 255, 255, 255), 0.9, "default-bold", "left", "top",false, true)
	--dxDrawText(getElementData(resourceRoot, "news:text") or "Please report this to an ingame admin.", screenX / 2 + 160, screenY / 2 - 80, screenX / 2 + 550, 300, tocolor(255, 255, 255, 255), 0.9, "default-bold", "left", "top",false, true)
end																										

ifnews = false
function togNewsRender ()
	if ifnews == false then
		addEventHandler("onClientRender", root, togNews)
		ifnews = true
	else
		removeEventHandler("onClientRender", root, togNews)
		ifnews = false
	end
end
