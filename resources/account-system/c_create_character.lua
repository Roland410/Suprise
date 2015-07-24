local gui = {}
local curskin = 1
local dummyPed = nil
local languageselected = 1
function newCharacter_init()
	guiSetInputEnabled(true)
	setCameraInterior(14)
	setCameraMatrix(254.7190,  -41.1370,  1002, 256.7190,  -41.1370,  1002 )
	dummyPed = createPed(217, 258,  -42,  1002)
	setElementInterior(dummyPed, 14)
	setElementInterior(getLocalPlayer(), 14)
	setPedRotation(dummyPed, 87)
	setElementDimension(dummyPed, getElementDimension(getLocalPlayer()))
	
	local screenX, screenY = guiGetScreenSize()
	
	gui["_root"] = guiCreateWindow(0, screenY/2-225, 255, 557, "Karakter létrehozása", false)
	guiWindowSetSizable(gui["_root"], false)
		
	gui["lblCharName"] = guiCreateLabel(10, 25, 91, 16, "Karakter neve:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblCharName"], "left", false)
	guiLabelSetVerticalAlign(gui["lblCharName"], "center")
	
	gui["txtCharName"] = guiCreateEdit(95, 24, 151, 20, "", false, gui["_root"])
	guiEditSetMaxLength(gui["txtCharName"], 32767)
	
	gui["lblCharNameExplanation"] = guiCreateLabel(10, 45, 240, 80,"Az alábbi példa szerint válassz nevet: \n     Vezetéknév Keresztnév\nPéldául: Joe Harisson. Egy realisztikus\nnevet kell használnod. (nem használhatsz\nhíresség neveket!)", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblCharNameExplanation"], "left", false)
	guiLabelSetVerticalAlign(gui["lblCharNameExplanation"], "center")
	
	gui["lblCharDesc"] = guiCreateLabel(10, 125, 120, 16, "Karakter leírás:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblCharDesc"], "left", false)
	guiLabelSetVerticalAlign(gui["lblCharDesc"], "center")

	gui["memCharDesc"] = guiCreateMemo(10, 145, 231,100, "", false, gui["_root"])

	gui["lblCharDescExplanation"] = guiCreateLabel(10, 245, 231, 61, "Írj egy leírást a karakteredről, \npéldául hogyan néz ki és \nmilyen más tulajdonságai vannak. Minimum\n50 betű hosszú legyen!", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblCharDescExplanation"], "left", false)
	guiLabelSetVerticalAlign(gui["lblCharDescExplanation"], "center")
	
	gui["lblGender"] = guiCreateLabel(10, 343, 46, 13, "Nem:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblGender"], "left", false)
	guiLabelSetVerticalAlign(gui["lblGender"], "center")
	gui["rbMale"] = guiCreateRadioButton(90, 342, 51, 17, "Férfi", false, gui["_root"])
	gui["rbFemale"] = guiCreateRadioButton(150, 342, 82, 17, "Nő", false, gui["_root"])
	guiRadioButtonSetSelected ( gui["rbMale"], true)
	addEventHandler("onClientGUIClick", gui["rbMale"], newCharacter_updateGender, false)
	addEventHandler("onClientGUIClick", gui["rbFemale"], newCharacter_updateGender, false)
	
	gui["lblSkin"] = guiCreateLabel(10, 360, 80, 16, "Kinézet:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblSkin"], "left", false)
	guiLabelSetVerticalAlign(gui["lblSkin"], "center")
	
	gui["btnPrevSkin"] = guiCreateButton(10, 380, 111, 23, "Előző", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnPrevSkin"], newCharacter_updateGender, false)
	gui["btnNextSkin"] = guiCreateButton(130, 380, 111, 23, "Következő", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnNextSkin"], newCharacter_updateGender, false)
	
	gui["lblRace"] = guiCreateLabel(10, 314, 111, 16, "Bőrszín", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblRace"], "left", false)
	guiLabelSetVerticalAlign(gui["lblRace"], "center")
	
	gui["chkBlack"] =  guiCreateCheckBox ( 60, 315, 55, 15, "Fekete", true, false, gui["_root"] )
	addEventHandler("onClientGUIClick", gui["chkBlack"] , newCharacter_raceFix, false)
	gui["chkWhite"] =  guiCreateCheckBox ( 120, 315, 55, 15, "Fehér", false, false, gui["_root"] )
	addEventHandler("onClientGUIClick", gui["chkWhite"] , newCharacter_raceFix, false)
	gui["chkAsian"] =  guiCreateCheckBox ( 180, 315, 55, 15, "Ázsiai", false, false, gui["_root"] )
	addEventHandler("onClientGUIClick", gui["chkAsian"] , newCharacter_raceFix, false)
	
	gui["lblHeight"] = guiCreateLabel(10, 405, 111, 16, "Magasság", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblHeight"], "left", false)
	guiLabelSetVerticalAlign(gui["lblHeight"], "center")
	
	gui["scrHeight"] =  guiCreateScrollBar ( 110, 405, 130, 16, true, false, gui["_root"])
	addEventHandler("onClientGUIScroll", gui["scrHeight"], newCharacter_updateScrollBars, false)
	guiSetProperty(gui["scrHeight"], "StepSize", "0.02")

	gui["lblWeight"] = guiCreateLabel(10, 426, 111, 16, "Súly", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblWeight"], "left", false)
	guiLabelSetVerticalAlign(gui["lblWeight"], "center")
	
	gui["scrWeight"] =  guiCreateScrollBar ( 110, 426, 130, 16, true, false, gui["_root"])
	addEventHandler("onClientGUIScroll", gui["scrWeight"], newCharacter_updateScrollBars, false)
	guiSetProperty(gui["scrWeight"], "StepSize", "0.01")
	
	gui["lblAge"] = guiCreateLabel(10, 447, 111, 16, "Kor:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblAge"], "left", false)
	guiLabelSetVerticalAlign(gui["lblAge"], "center")
	
	gui["scrAge"] =  guiCreateScrollBar ( 110, 447, 130, 16, true, false, gui["_root"])
	addEventHandler("onClientGUIScroll", gui["scrAge"], newCharacter_updateScrollBars, false)
	guiSetProperty(gui["scrAge"], "StepSize", "0.0125")
	
	gui["lblLanguage"] = guiCreateLabel(10, 468, 111, 16, "Anyanyelv:", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblLanguage"], "left", false)
	guiLabelSetVerticalAlign(gui["lblLanguage"], "center")
	
	gui["btnLanguagePrev"] = guiCreateButton(110, 468, 16, 16, "<", false, gui["_root"])
	gui["lblLanguageDisplay"] = guiCreateLabel(130, 468, 111, 16, "Angol", false, gui["_root"])
	gui["btnLanguageNext"] = guiCreateButton(224, 468, 16, 16, ">", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnLanguagePrev"] , newCharacter_updateLanguage, false)
	addEventHandler("onClientGUIClick", gui["btnLanguageNext"] , newCharacter_updateLanguage, false)
	
	gui["btnCancel"] = guiCreateButton(10, 495, 231, 21, "Mégse", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCancel"], newCharacter_cancel, false)
	
	gui["btnCreateChar"] = guiCreateButton(10, 515, 231, 41, "Karakter létrehozása", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCreateChar"], newCharacter_attemptCreateCharacter, false)
	newCharacter_changeSkin()
	newCharacter_updateScrollBars()
end

function newCharacter_raceFix()
	guiCheckBoxSetSelected ( gui["chkAsian"], false )
	guiCheckBoxSetSelected ( gui["chkWhite"], false )
	guiCheckBoxSetSelected ( gui["chkBlack"], false )
	if (source == gui["chkBlack"]) then
		guiCheckBoxSetSelected ( gui["chkBlack"], true )
	elseif (source == gui["chkWhite"]) then
		guiCheckBoxSetSelected ( gui["chkWhite"], true )
	elseif (source == gui["chkAsian"]) then
		guiCheckBoxSetSelected ( gui["chkAsian"], true )
	end
	
	curskin = 1
	newCharacter_changeSkin(0)
end

function newCharacter_updateGender()
	local diff = 0
	if (source == gui["btnPrevSkin"]) then
		diff = -1
	elseif (source == gui["btnNextSkin"]) then
		diff = 1
	else
		curskin = 1
	end
	newCharacter_changeSkin(diff)
end

function newCharacter_updateLanguage()

	if source == gui["btnLanguagePrev"] then
		if languageselected == 1 then
			languageselected = call( getResourceFromName( "language-system" ), "getLanguageCount" )
		else
			languageselected = languageselected - 1
		end
	elseif source == gui["btnLanguageNext"] then
		if languageselected == call( getResourceFromName( "language-system" ), "getLanguageCount" ) then
			languageselected = 1
		else
			languageselected = languageselected + 1
		end
	end

	guiSetText(gui["lblLanguageDisplay"], tostring(call( getResourceFromName( "language-system" ), "getLanguageName", languageselected )))
end

function newCharacter_updateScrollBars()
	local scrollHeight = tonumber(guiGetProperty(gui["scrHeight"], "ScrollPosition")) * 100
	scrollHeight = math.floor((scrollHeight / 2) + 150)
	guiSetText(gui["lblHeight"], "Magasság: "..scrollHeight.." CM")
	
	local scrWeight = tonumber(guiGetProperty(gui["scrWeight"], "ScrollPosition")) * 100
	scrWeight = math.floor(scrWeight + 40)
	guiSetText(gui["lblWeight"], "Súly: "..scrWeight.." KG")
	
	local scrAge = tonumber(guiGetProperty(gui["scrAge"], "ScrollPosition")) * 100
	scrAge = math.floor( (scrAge * 0.8 ) + 18 )
	guiSetText(gui["lblAge"], "Kor: "..scrAge.." éves")
end

function newCharacter_changeSkin(diff)
	local array = newCharacters_getSkinArray()
	local skin = 0
	if (diff ~= nil) then
		curskin = curskin + diff
	end
	
	if (curskin > #array or curskin < 1) then
		curskin = 1
		skin = array[1]
	else
		curskin = curskin
		skin = array[curskin]
	end
	
	if skin ~= nil then
		setElementModel(dummyPed, tonumber(skin))
	end
end

function newCharacters_getSkinArray()
	local array = { }
	if (guiCheckBoxGetSelected( gui["chkBlack"] )) then -- BLACK
		if (guiRadioButtonGetSelected( gui["rbMale"] )) then -- BLACK MALE
			array = blackMales
		elseif (guiRadioButtonGetSelected( gui["rbFemale"] )) then -- BLACK FEMALE
			array = blackFemales
		else
			outputChatBox("Először válaszd ki a nemed!", 0, 255, 0)
		end
	elseif ( guiCheckBoxGetSelected( gui["chkWhite"] ) ) then -- WHITE
		if ( guiRadioButtonGetSelected( gui["rbMale"] ) ) then -- WHITE MALE
			array = whiteMales
		elseif ( guiRadioButtonGetSelected( gui["rbFemale"] ) ) then -- WHITE FEMALE
			array = whiteFemales
		else
			outputChatBox("Először válaszd ki a nemed!", 0, 255, 0)
		end
	elseif ( guiCheckBoxGetSelected( gui["chkAsian"] ) ) then -- ASIAN
		if ( guiRadioButtonGetSelected( gui["rbMale"] ) ) then -- ASIAN MALE
			array = asianMales
		elseif ( guiRadioButtonGetSelected( gui["rbFemale"] ) ) then -- ASIAN FEMALE
			array = asianFemales
		else
			outputChatBox("Először válaszd ki a nemed!", 0, 255, 0)
		end
	end
	return array
end

function newCharacter_cancel(hideSelection)
	guiSetInputEnabled(false)
	destroyElement(dummyPed)
	destroyElement(gui["_root"])
	gui = {}
	curskin = 1
	dummyPed = nil
	languageselected = 1
	if hideSelection ~= true then
		Characters_showSelection()
	end
	clearChat()
end

function newCharacter_attemptCreateCharacter()
	local characterName = guiGetText(gui["txtCharName"])
	local nameCheckPassed, nameCheckError = checkValidCharacterName(characterName) 
	if not nameCheckPassed then
		LoginScreen_showWarningMessage( "Hiba a karakter név feldolgozásakor:\n".. nameCheckError )
		return
	end
	
	local characterDescription = guiGetText(gui["memCharDesc"])
	if #characterDescription < 50 then
		LoginScreen_showWarningMessage( "Hiba:\nA leírás nem elég hosszú minimum 50 karakter legyen." )
		return
	elseif #characterDescription > 128 then
		LoginScreen_showWarningMessage( "Hiba\nA leírás túl hosszú,Maximum 128 legyen." )
		return
	end
	
	local race = 0
	if (guiCheckBoxGetSelected(gui["chkBlack"])) then
		race = 0
	elseif (guiCheckBoxGetSelected(gui["chkWhite"])) then
		race = 1
	elseif (guiCheckBoxGetSelected(gui["chkAsian"])) then
		race = 2
	else
		LoginScreen_showWarningMessage( "Hiba:\nNem választottál bőrszínt." )
		return
	end
	
	local gender = 0
	if (guiRadioButtonGetSelected( gui["rbMale"] )) then
		gender = 0
	elseif (guiRadioButtonGetSelected( gui["rbFemale"] )) then
		gender = 1
	else
		LoginScreen_showWarningMessage( "Hiba:\nNem választottál nemet." )
		return
	end
	
	local skin = getElementModel( dummyPed )
	if not skin then
		LoginScreen_showWarningMessage( "Hiba:\nNem választottál skint." )
		return
	end
	
	local scrollHeight = guiScrollBarGetScrollPosition(gui["scrHeight"])
	scrollHeight = math.floor((scrollHeight / 2) + 150)
	
	local scrWeight = guiScrollBarGetScrollPosition(gui["scrWeight"])
	scrWeight = math.floor(scrWeight + 50)
	
	local scrAge = guiScrollBarGetScrollPosition(gui["scrAge"])
	scrAge = math.floor( (scrAge * 0.8 ) + 18 )

	if languageselected == nil then
		LoginScreen_showWarningMessage( "Hiba:\nNem választottál ki anyanyelvet." )
		return
	end
	guiSetEnabled(gui["btnCancel"], false)
	guiSetEnabled(gui["btnCreateChar"], false)
	guiSetEnabled(gui["_root"], false)
	setTimer ( pilota, 3000, 1)
	triggerServerEvent("accounts:characters:new", getLocalPlayer(), characterName, characterDescription, race, gender, skin, scrollHeight, scrWeight, scrAge, languageselected )
end

function pilota()
   zene = playSound( "Malev.mp3", true)
   setTimer ( uzenet, 65000, 1)
end

function uzenet ()

outputChatBox("Leszállást hamarosan megkezdjük(kb 10 Másodperc)", 255, 0, 0)
stopSound (zene)
setTimer ( kirakrepter, 11000, 1)
end

function kirakrepter()
    
setElementPosition ( getLocalPlayer(), -2551.8000488281, 751.59997558594, -73.199996948242 )
setElementInterior ( getLocalPlayer(), 11 )
	setElementDimension ( getLocalPlayer(), 791 )
	outputChatBox("Üdvözöljük a Fly-City Reptéren", 255, 0, 0)
end
--addCommandHandler ( "greet", kirakrepter )




function newCharacter_response(statusID, statusSubID)
	if (statusID == 1) then
		LoginScreen_showWarningMessage( "Hoppá, hiba történt, próbáld újra\nvagy keresd fel az egyik admint.\nACC hiba"..tostring(statusSubID) )
	elseif (statusID == 2) then
		if (statusSubID == 1) then
			LoginScreen_showWarningMessage( "Sajnos ez a karakter név már\nhasználatban van. :(!" )
		else
			LoginScreen_showWarningMessage( "Hoppá, hiba történt, próbáld újra\nvagy keresd fel az egyik admint.\nACD hiba"..tostring(statusSubID) )
		end
	elseif (statusID == 3) then
		newCharacter_cancel(true)
		triggerServerEvent("accounts:characters:spawn", getLocalPlayer(), statusSubID)
		return
	end
	
	guiSetEnabled(gui["btnCancel"], true)
	guiSetEnabled(gui["btnCreateChar"], true)	
	guiSetEnabled(gui["_root"], true)
	
end
addEventHandler("accounts:characters:new", getRootElement(), newCharacter_response)