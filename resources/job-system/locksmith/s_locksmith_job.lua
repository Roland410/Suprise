function makeKey(thePlayer, commandName, keyType, keyID)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if(getElementData(thePlayer,"job")==6)then
			if not (keyType) or not (keyID) then
				outputChatBox("HASZNÁLAT: /" .. commandName .. " [Kulcs Típusa: 1=Ház 2=Biznisz 3=Jármű] [Kulcs ID]", thePlayer, 255, 194, 14)
			else
				if not exports.global:hasMoney(thePlayer, 25) then
					outputChatBox("Nincs elég pénzed(2000 Ft), hogy kulcsot másolj.", thePlayer, 255, 0, 0)
				else
					-- Translate keytype to key item IDs.
					if (tonumber(keyType) == 1) then
						itemID = 4 --House Key
						keyname = "lakás kulcs"
					elseif(tonumber(keyType) == 2) then
						itemID = 5 -- Business Key
						keyname = "biznisz kulcs"
					elseif(tonumber(keyType) == 3) then
						itemID = 3 -- Vehicle Key
						keyname = "jármű kulcs"
					end
					local success = exports.global:hasItem(thePlayer, tonumber(itemID), tonumber(keyID))
					if(success)then -- does the player have the key?
						exports.global:giveItem(thePlayer, tonumber(itemID), tonumber(keyID)) -- create a ket for the locksmith.
						exports.global:takeMoney(thePlayer, 2000) -- take the cost of making the key from the locksmith.
						outputChatBox("Lemásoltál egy ".. keyname .."ot(".. keyID ..") 2000 Ft-ért.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer,"lemásol egy ".. keyname .."ot.")
					else
						outputChatBox("Nincs nálad a lemásolandó kulcs!", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("kulcsmasolas", makeKey, false, false)