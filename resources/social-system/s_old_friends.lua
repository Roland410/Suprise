function declineFriendRequest(targetPlayer)
	outputChatBox(getPlayerName(source):gsub("_", " ") .. " declined your friend request.", targetPlayer, 255, 0, 0)
	outputChatBox(" csökkentek ".. getPlayerName(targetPlayer):gsub("_", " ") .." barátom kérésére.", source, 255, 0, 0)
end
addEvent("declineFriendSystemRequest", true)
addEventHandler("declineFriendSystemRequest", getRootElement(), declineFriendRequest)
