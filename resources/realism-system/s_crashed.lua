function quitPlayer(quitReason, reason)
	if not (getElementData(source, "reconx")) then
		if (quitReason == "Crashelt") or (quitReason == "Hibás csatlakozás") then
			exports.global:sendLocalText(source, "(( "..getPlayerName(source):gsub("_", " ").." disconnected (".. quitReason .."). ))", nil, nil, nil, 10)
		elseif (quitReason == "Kirugva" and reason == "AFK") then
			exports.global:sendLocalText(source, "(( "..getPlayerName(source):gsub("_", " ").." disconnected (AFK Kick). ))", nil, nil, nil, 10)
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)