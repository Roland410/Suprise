



function kocsiradio()

	local Width = 463
	local Height = 146
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	local kocsiban = getPedOccupiedVehicle(getLocalPlayer())
	if kocsiban then 
	if not (radio) then
	
		radio = guiCreateWindow(X, Y, Width, Height, "Autóradio", false)
		off = guiCreateStaticImage(0.0,0.05,1,0.95,"magno.png",true,radio)
		radioki = guiCreateStaticImage (24.8,57,47,13,"off.png",false,off)
		addEventHandler("onClientGUIClick",radioki,radiobezar,false)
		neofm = guiCreateStaticImage (225.8,90,18,10,"neofm.png",false,off)
		addEventHandler("onClientGUIClick",neofm,neo,false)
		classfm = guiCreateStaticImage (250.8,90,18,10,"class.png",false,off)
		addEventHandler("onClientGUIClick",classfm,class,false)
		discofm = guiCreateStaticImage (275.8,90,18,10,"disco.png",false,off)
		addEventHandler("onClientGUIClick",discofm,disco,false)
		teknofm = guiCreateStaticImage (300.8,90,18,10,"tekno.png",false,off)
		addEventHandler("onClientGUIClick",teknofm,tekno,false)
		nyirfm = guiCreateStaticImage (325.8,90,18,10,"nyir.png",false,off)
		addEventHandler("onClientGUIClick",nyirfm,nyir,false)
		
		showCursor(true)
		guiSetInputEnabled(true)
		outputChatBox("#0AF430Bekapcsoltad a radiót.",255,255,255, true)
	end
	else
	outputChatBox("#FF9933Nem vagy kocsiban.",255,255,255, true)
end
end
addCommandHandler("kradio", kocsiradio)



function radiobezar(button, state)
	if (source==radioki) then
		destroyElement(radio)
		destroyElement(off)
		--destroyElement(neofm)
		--radio,off,neofm = nil, nil, nil	
		showCursor(false)
	outputChatBox("#FF9933Kikapcsoltad a radiót.",255,255,255, true)
	guiSetInputEnabled(false)
	playBeep();
	stopSound ( sound2 );
	stopSound ( sound3 );
	stopSound ( sound4 );
	stopSound ( sound5 );
	stopSound ( sound6 );
	radio,off = nil, nil
	end
	
	
end


function nyir(button, state)
	if (source==nyirfm) then
	destroyElement(radio)
		destroyElement(off)
		showCursor(false)
	stopSound ( sound2 );
	stopSound ( sound3 );
	stopSound ( sound4 );
	stopSound ( sound5 );
	
	guiSetInputEnabled(false)
	radio,off = nil, nil
	sound6 = playSound("http://91.120.50.11:8000/listen")
	outputChatBox("#FF9933Átváltottad a radiót a Nyiregyháza Fm-re.",255,255,255, true)
	playBeep();
	end
end

function tekno(button, state)
	if (source==teknofm) then
	destroyElement(radio)
		destroyElement(off)
		showCursor(false)
	stopSound ( sound2 );
	stopSound ( sound3 );
	stopSound ( sound4 );
	stopSound ( sound6 );
	
	guiSetInputEnabled(false)
	radio,off = nil, nil
	sound5 = playSound("http://dsl.tb-stream.net:80")
	outputChatBox("#FF9933Átváltottad a radiót a Techno-ra.",255,255,255, true)
	playBeep();
	end
end


function disco(button, state)
	if (source==discofm) then
	destroyElement(radio)
		destroyElement(off)
		showCursor(false)
	stopSound ( sound2 );
	stopSound ( sound3 );
	stopSound ( sound5 );
	stopSound ( sound6 );
	
	guiSetInputEnabled(false)
	radio,off = nil, nil
	sound4 = playSound("http://discoshit.hu/ds-radio.m3u")
	outputChatBox("#FF9933Átváltottad a radiót a Disco Shit-re.",255,255,255, true)
	playBeep();
	end
end

function class(button, state)
	if (source==classfm) then
	destroyElement(radio)
		destroyElement(off)
		showCursor(false)
	stopSound ( sound2 );
	stopSound ( sound4 );
	stopSound ( sound5 );
	stopSound ( sound6 );
	
	guiSetInputEnabled(false)
	radio,off = nil, nil
	sound3 = playSound("http://87.229.103.50:7058/CLASS_FM")
	outputChatBox("#FF9933Átváltottad a radiót a Class Fm-re.",255,255,255, true)
	playBeep();
	end
end




function neo(button, state)
	if (source==neofm) then
	destroyElement(radio)
		destroyElement(off)
		showCursor(false)
	guiSetInputEnabled(false)
	stopSound ( sound3 );
	stopSound ( sound4 );
	stopSound ( sound5 );
	stopSound ( sound6 );
	radio,off = nil, nil
	sound2 = playSound("http://live.risefm.hu/radio.m3u")
	outputChatBox("#FF9933Bekapcsoltad a radiót a Rise Fm-re.",255,255,255, true)
	playBeep();
	end
end

function playBeep()
    local beep = playSound("beep.wav");
    return beep;
end


addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() then
            stopSound ( sound2 );
			stopSound ( sound3 );
			stopSound ( sound4 );
			stopSound ( sound5 );
			stopSound ( sound6 );
			
        end
    end
)


