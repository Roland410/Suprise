wRook, optionOne, optionTwo, rookText = nil

function createRookGUI() 
	
	-- Window variables
	local Width = 400
	local Height = 250
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	if not (wRook) then
	
		-- Create the window
		wRook = guiCreateWindow(X, Y, Width, Height, "Párbeszéd az ismeretlennel.", false )
		
		-- Create Stevies text box
		rookText = guiCreateLabel ( 0.05, 0.1, 0.9, 0.3, "Mi a helyzet? Csak nem néhány zöldhasút akarsz keresni?", true, wRook )
		guiLabelSetHorizontalAlign ( rookText, "left", true )
		
		-- Create close, previous and Next Button
		optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Hogy a faszba ne, állandóan csak azt a szaros papírt keresem.", true, wRook )
		addEventHandler( "onClientGUIClick", optionOne, rookStatement2, false )

		optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Faszt, nekem nem kell pénz, van elég. ", true, wRook )
		addEventHandler( "onClientGUIClick", optionTwo, rookStatement3, false ) -- Trigger Server side event
		
		showCursor(true)
	end
end
addEvent( "rookIntroEvent", true )
addEventHandler( "rookIntroEvent", getRootElement(), createRookGUI )

function destroyRookGUI()
	-- destroy all possibly created windows
	if optionOne then
		destroyElement ( optionOne )
		optionOne = nil
	end
	
	if optionTwo then
		destroyElement ( optionTwo )
		optionTwo = nil
	end
	
	if rookText then
		destroyElement ( rookText )
		rookText = nil
	end
	
	if wRook then
		destroyElement ( wRook )
		wRook = nil
	end

	showCursor(false)
end

-- make sure to quit the Convo GUI when player is killed
addEventHandler("onClientPlayerWasted", getLocalPlayer(), destroyRookGUI)
addEventHandler("onClientChangeChar", getRootElement(), destroyRookGUI)

-- Statement 2
function rookStatement2()
	
	triggerServerEvent( "rookStatement2ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "A szarka mondja: A gazdaság lineárisan megy le mi? Csak egy piac nincs leáldozóban. Dopping pénzről beszélek." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Mit tudsz a témáról?", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement4, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Az egyetlen doppingszer ami engedélyezett az a börtön.", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement3, false )
	
end

-- statement 3
function rookStatement3()
	
	triggerServerEvent( "rookStatement3ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyRookGUI()
end

-- Statement 4
function rookStatement4()
	
	triggerServerEvent( "rookStatement4ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "A szarka mondja: Ismerek egy srácot aki vevőkre vár. De nem osztogatja ingyen a dolgokat." )
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Árnyas hangok, váh. ", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Hol van ez a 'srác'?", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement5, false )
	
end

-- Statement 5
function rookStatement5()
	
	triggerServerEvent( "rookStatement5ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "A szarka mondja: A neve TY s a Kennedy Apartmanokon túl, Panoptican Avenue apartman ház, 3-as szám. Mondd neki hogy a 'szarka' küldött.")
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Persze még csak az kéne. Kiütnek a cipőmből, ha érted mire gondolok.", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Csak azért mondod ezt mert jótékonykodni akarsz?", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookStatement6, false )
	
end

-- Statement 6
function rookStatement6()
	
	triggerServerEvent( "rookStatement6ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option
	
	-- Destroy the old options
	destroyElement ( optionOne )
	destroyElement ( optionTwo )
	optionOne = nil
	optionTwo = nil
	
	-- Create new Stevies text box
	guiSetText ( rookText, "A szarka mondja: Ha valaki nem vigyáz a saját testvéreire akkor ki fog? A fehér ember?")
	
	-- Create the new options
	optionOne = guiCreateButton( 0.05, 0.35, 0.9, 0.2, "Néhány fekete párduc.", true, wRook )
	addEventHandler( "onClientGUIClick", optionOne, rookStatement3, false ) -- New event handlers to different functions.

	optionTwo = guiCreateButton( 0.05, 0.55, 0.9, 0.2, "Vágom, nincs több kérdésem.", true, wRook )
	addEventHandler( "onClientGUIClick", optionTwo, rookClose, false )
	
end

-- close
function rookClose()
	
	triggerServerEvent( "rookStatement7ServerEvent", getLocalPlayer() ) -- Trigger Server Event to output previous option

	-- Destroy elements
	destroyRookGUI()
end
