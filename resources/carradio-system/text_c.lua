local sTextToShow;
local tTextDieTimer;
local xSize,ySize = guiGetScreenSize ();

function triggerRemoveText()
	sTextToShow = "";
	tTextDieTimer = nil;
end

function triggerShowText(sName)
	sTextToShow = tostring(sName);
	if isElement(tTextDieTimer) then
		killTimer(tTextDieTimer);
	end
	tTextDieTimer = setTimer(triggerRemoveText,6600,1);
end

function text_OnFrameRender()
	if sTextToShow and sTextToShow ~= "" then
		local team = getPlayerTeam(getLocalPlayer());
		local color = tocolor(255,0,0);
		if team then
			local r,g,b = getTeamColor(team);
			color = tocolor(r,g,b);
		end
		dxDrawText ( 	sTextToShow,--string text,
				0.2*xSize,--int left,
				0.0*ySize,--int top [,
				0.8*xSize,--int right=left,
				0.1*ySize,--int bottom=top,
				color,--int color=white,
				1.0*xSize/600,--float scale=1,
				"arial",--string font="default",
				"center",--string alignX="left",
				"center",--string alignY="top",
				true,--bool clip=false, 
				true,--bool wordBreak=false,
				false)--bool postGUI] )
	end
end
addEventHandler ("onClientRender", getRootElement(),text_OnFrameRender)