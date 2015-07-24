addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['global']:sendLocalText(client, "Győrfi Pál mondja: Hello, miben tudok segíteni ma?", 255, 255, 255, 10)
	--exports.global:sendLocalMeAction(source,"hands " .. genderm .. " collection of photographs to the woman behind the desk.")
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['global']:sendLocalText(client, pedName.." mondja: Ó, tényleg? Hívom valakit azonnal!", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] Kérem valaki jöjjön kórház recepcióra köszönöm vége.", value, 0, 183, 239)
		outputChatBox("[RADIO] Esemény: Valakinek azonnali segitségre van szüksége, vége.  ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Pozició: Központi kórház. Vége.. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['global']:sendLocalText(client, "Győrfi Pál mondja: Értesitettem minden munkatársat,kérem foglaljon helyet és legyen türelemmel.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Services") ) ) do
		outputChatBox("[RADIO] This is the reception speaking, uhm, we've got someone waiting here for their appointment. ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Location: The hospital at the reception, Over. (("..pedName.."))", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)