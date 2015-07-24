wHunter, optionOne, optionTwo, hunterText = nil

function createhunterGUI() 
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wHunter) then
		-- Create the window
		wHunter = guiCreateWindow(X, Y, Width, Height, "Párbeszéd az idegennel.", false )
		
		-- Create Stevies text box
		hunterText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3,  "*Egy izmos ember dolgozik a motorháztető alatt.", true, wHunter )
		guiLabelSetHorizontalAlign ( hunterText, "left", true )
		
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Héé. Ki kéne cserélni néhány gyertyát.", true, wHunter )
		addEventHandler( "onClientGUIClick", optionOne, hunterStatement2, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, " Szép kocsi. A magáé?", true, wHunter )
		addEventHandler( "onClientGUIClick", optionTwo, hunterStatement3, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent( "hunterIntroEvent", true )
addEventHandler( "hunterIntroEvent", getRootElement(), createhunterGUI )

function destroyHunterGUI()
	-- destroy all possibly created windows
	if optionOne then
		destroyElement ( optionOne )
		optionOne = nil
	end
	
	if optionTwo then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	
	if hunterText then
		destroyElement ( hunterText )
		hunterText = nil
	end
	
	if wHunter then
		destroyElement ( wHunter )
		wHunter = nil
	end

	showCursor(false)
end

-- make sure to quit the Convo GUI when player is killed
addEventHandler("onClientPlayerWasted", getLocalPlayer(), destroyHunterGUI)
addEventHandler("onClientChangeChar", getRootElement(), destroyHunterGUI)

-- statement 2
function hunterStatement2()
	
	triggerServerEvent( "hunterStatement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
end

-- Statement 3
function hunterStatement3()
	
	triggerServerEvent( "hunterStatement3ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( hunterText, "A vadász mondja: Az már biztos." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Mi van a motorháztető alatt?", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Jó festés.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement5, false )
	
end

-- statement 4
function hunterStatement4()
	
	triggerServerEvent( "hunterStatement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create Stevies text box
	guiSetText (hunterText, "A vadász mondja: Légbeömlő, Nitró, porlasztó és T4 turbó. De te nem tudsz sokat ezekről, ugye?" )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Nem igazán az én asztalom.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement6, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Ez egy AIC vezérlő? .. És egy közvetlen nitró injektor?!", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement7, false )
	
end

-- statement 5
function hunterStatement5()
	
	triggerServerEvent( "hunterStatement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
end

-- statement 6
function hunterStatement6()
	
	triggerServerEvent( "hunterStatement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyHunterGUI()
	
end

-- Statement 7
function hunterStatement7()
	
	triggerServerEvent( "hunterStatement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText (hunterText, "A vadász mondja: Úgy néz ki tudod miről beszélsz." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Nincs jobb annál mint innen negyed mérföldre lakni.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement8, false )
	
end



-- Statement 8
function hunterStatement8()
	
	triggerServerEvent( "hunterStatement8ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	optionOne = nil
	
	-- Create Stevies text box
	guiSetText ( hunterText, "A vadász mondja: Ó, hogy versenyző lennél? 'Vadász'-nak hívnak. Van valódi nevem is de hacsak nem vagy zsaru nem kell tudnod." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Egyedül dolgozol?", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement9, false )

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Anyám azt mondta hogy sose bízzak olyan emberekben akik nem mondják el a nevüket.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement10, false )
	
end

-- Statement 9
function hunterStatement9()
	
	triggerServerEvent( "hunterStatement9ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end

-- Statement 10
function hunterStatement10()
	
	triggerServerEvent( "hunterStatement10ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil

	-- Create Stevies text box
	guiSetText ( hunterText, "A vadász mondja: Nos van egy dolog. Néhány napja az egyik haveromat letartóztatták. Ha szeretnél egy kis pénzt keresni pont szükségem van egy új fiúra. De egy ilyen kocsi mint ez nem túl olcsó ...kölcsön kocsi kell ha érted mire gondolok." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.45, 0.9, 0.2, "Könnyű prédának hangzik. Hívj fel.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionOne, hunterStatement11, false )

	optionTwo = guiCreateButton( 0.05, 0.65, 0.9, 0.2, "Inkább nem akarok részt venni.", true, wHunter )
	addEventHandler( "onClientGUIClick", optionTwo, hunterStatement12, false )
	
end

-- Hunter Success
function hunterStatement11()
	
	triggerServerEvent( "hunterStatement11ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end

-- Hunter Decline
function hunterStatement12()
	
	triggerServerEvent( "hunterStatement12ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy elements
	destroyHunterGUI()
end
