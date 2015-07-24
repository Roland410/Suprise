aChannelList = {};
--bool setElementData ( element theElement, string key, var value [, bool synchronize = true ] )
iCurrentChannel = 0;
currentSound = nil;
iCurrentText = nil;
bRender = true;

local function showText(sText)
	if not iCurrentText then
		iCurrentText = oTextList_functions.newText(sText,0.3,0.1,0.3,0.1,200,200,0,0,"default","left","top",true,true);
	end
	oTextList_functions.setText(iCurrentText,sText);
	triggerShowText(sText);
end

local function playChannel(id)
	setRadioChannel(0);
	if currentSound then
		stopSound(currentSound);
		destroyElement(currentSound);
	end
	currentSound = nil;
	if aChannelList[id] and aChannelList[id].addr ~= "" then
		currentSound = playSound(aChannelList[id].addr,true)
		setElementData ( utolsokocsi, "radio.rid", id);
		local jatekosid = getElementData ( getLocalPlayer(), "playerid" )
		exports.global:sendLocalMeAction(jatekosid, "átkapcsolta a kocsirádiót egy másik csatornára")
		local occupants = getVehicleOccupants(utolsokocsi)
		local seats = getVehicleMaxPassengers(utolsokocsi)
		for seat = 0, seats do
			local occupant = occupants[seat]
			if occupant and getElementType(occupant) == "player" then 
				local playerid = getPlayerFromName (occupant) 
				triggerClientEvent ( "radio.play", playerid, id)
			end
		end
	end
	showText(aChannelList[id].name);
end
addEvent( "radio.play", true )
addEventHandler( "radio.play", getRootElement(), playChannel )

local function addNewChannel(sName,sWebAddress,sImageName)
	local iCount = #aChannelList;
	iCount = iCount + 1;
	aChannelList[iCount] = {};
	aChannelList[iCount].name = sName;
	aChannelList[iCount].addr = sWebAddress;
	aChannelList[iCount].imge = sImageName;
end

local function getNextChannel()
	iCurrentChannel = iCurrentChannel + 1;
	if iCurrentChannel > #aChannelList then
		iCurrentChannel = 1;
	end
	playChannel(iCurrentChannel)
end

local function getPrevChannel()
	iCurrentChannel = iCurrentChannel - 1;
	if iCurrentChannel < 0 then
		iCurrentChannel = #aChannelList;
	end
	playChannel(iCurrentChannel);
end

local function INIT_RADIO()
	bindKey("radio_next","down",getNextChannel);
	bindKey("radio_previous","down",getPrevChannel);

	toggleControl("radio_next",false);
	toggleControl("radio_previous",false);

	addNewChannel("Kikapcsolva","","off");
	addNewChannel("Rádió 1","http://dsl.tb-stream.net:80","tecno");
	addNewChannel("MiNiMaL","http://stream.uzic.ch:9010/","minimal");
	addNewChannel("RetroRádio","http://91.120.50.11:8000/listen","retro");
	addNewChannel("Rádió 1","http://195.70.35.172:8000/radio1.mp3.m3u","radio1");
	addNewChannel("Bartok rádió","http://stream001.radio.hu/mr3.asx","stream001");
end

local function DEINIT_RADIO()
	toggleControl("radio_next",true);
	toggleControl("radio_previous",true);
	unbindKey("radio_next","down",getNextChannel);
	unbindKey("radio_previous","down",getPrevChannel);
end


addEventHandler("onClientResourceStart",getResourceRootElement(),INIT_RADIO); 
addEventHandler("onClientResourceStop",getResourceRootElement(),DEINIT_RADIO); 

addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() then
            utolsokocsi = source
			local radioid = getElementData ( utolsokocsi, "radio.rid")
			if aChannelList[radioid] and aChannelList[radioid].addr ~= "" then
				playChannel(radioid);
				--outputChatBox("Debug: Beszálltál a kocsiba, és a rádió elindult!",255,255,255)
			end
			if seat == 0 then
				bindKey("radio_next","down",getNextChannel);
				bindKey("radio_previous","down",getPrevChannel);
				toggleControl("radio_next",false);
				toggleControl("radio_previous",false);
			else	
				unbindKey("radio_next","down",getNextChannel);
				unbindKey("radio_previous","down",getPrevChannel);
				toggleControl("radio_next",false);
				toggleControl("radio_previous",false);
			end
        end
    end
)
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == getLocalPlayer() then
            stopSound ( currentSound );
			--outputChatBox("Debug: Kiszálltál a kocsiból",255,255,255)		
        end
    end
)