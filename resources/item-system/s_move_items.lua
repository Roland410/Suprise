local function canAccessElement( player, element )
	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function output(from, to, itemID, itemValue)
	--outputDebugString("item-system\s_move_items.lua\output To: ".. getElementType(to) .. " From: ".. getElementType(to) )
	-- player to player
	if from ~= to and getElementType(from) == "player" and getElementType(to) == "player" then
		exports.global:sendLocalMeAction( from, "átadott " .. getPlayerName( to ):gsub("_", " ") .. "-nak/nek egy " .. getItemName( itemID, itemValue ) .. "-t." )
	-- player to item
	elseif from ~= to and getElementType(from) == "player" then
		local name = getElementModel( to ) == 2147 and "hűtő" or getElementModel(to) == 3761 and "szekrény" or ( getElementType( to ) == "vehicle" and "jármű" or ( getElementType( to ) == "player" and "player" or "széf" ) )
		exports.global:sendLocalMeAction( from, "berakott egy " .. getItemName( itemID, itemValue ) .. "-t a ".. name .."-ba/be." )
	-- item to player
	elseif from ~= to and getElementType(to) == "player" then
		local name = getElementModel( from ) == 2147 and "hűtő" or getElementModel(from) == 3761 and "szekrény" or ( getElementType( from ) == "vehicle" and "jármű" or ( getElementType( from ) == "player" and "player" or "széf" ) )
		exports.global:sendLocalMeAction( to, "kivett egy " .. getItemName( itemID, itemValue ) .. "-t a ".. name .."-ból/ből." )
	end
end
function x_output_wrapper( ... ) return output( ... ) end

--

local function moveToElement( element, slot, ammo, event )
	if not canAccessElement( source, element ) then
		outputChatBox("Nem éred el ezt a tárgyat jelenleg.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end
	
	local name = getElementModel( element ) == 2147 and "Hűtő" or getElementModel(source) == 3761 and "Szekrény" or ( getElementType( element ) == "vehicle" and "Jármű" or ( getElementType( element ) == "player" and "Játékos" or "Széf" ) )
			
	if not ammo then
		local item = getItems( source )[ slot ]
		if item then
				if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
					triggerEvent("shop:handleSupplies", source, element, slot, event)
					return
					--triggerClientEvent( source, event or "finishItemMove", source )
				end
		
			if not hasSpaceForItem( element, item[1], item[2] ) then
				outputChatBox( "A zsebed tele van.", source, 255, 0, 0 )
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
						outputChatBox("A fegyveredet nem tudod belerakni a " .. name .. "-ba/be miközben szolgálatban vagy.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 116) then -- Ammo
					local ammoDetails = exports.global:explode( ":", item[2]  )
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then -- /duty
						outputChatBox("A szolgálati töltényedet nem tudod belerakni a " .. name .. "-ba/be ameddig szolgálatban vagy.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				end
			
				if getElementType( element ) == "object" then -- safe
					if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
						if countItems( source, item[1], item[2] ) < 2 then
							outputChatBox("Nem rakhatod bele az egyetlen kulcsodat ehhez a széfhez ebbe a széfbe.", source, 255, 0, 0)
							triggerClientEvent( source, event or "finishItemMove", source )
							return
						end
					end
				end
			
				local success, reason = moveItem( source, element, slot )
				if not success then
					outputChatBox( "Mozgatás hiba: " .. tostring( reason ), source, 255, 0, 0 )
				else
					exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
					doItemGiveawayChecks( source, item[1] )
					output(source, element, item[1], item[2])
				end
			end
		end
	else
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "A zsebed tele van.", source, 255, 0, 0 )
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("A fegyveredet nem tudod belerakni a " .. name .. "-ba/be miközben szolgálatban vagy.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("Nem rakhatod pele a sprédet a " .. name .. "-ba/be.", source, 255, 0, 0)
			else
				if slot == -100 then 	
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( slot ) .. " - " .. ammo, 17)
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.global:sendMessageToAdmins("[items\moveToElement] Lehetséges fegyver duplázás '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo .. " BLOCKED DUE POSSIBLE DUPING", 17)
						return
					end
					exports.global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo, 17)
						output(source, element, -slot)
					end
				end
			end
		end
	end
	triggerClientEvent( source, event or "finishItemMove", source )
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end
	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		triggerEvent("shop:handleSupplies", source, element, -1, "worldItemMoveFinished", item)
		return
		--triggerClientEvent( source, event or "finishItemMove", source )
	end
	
	local id = getElementData( item, "id" )
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	local name = getElementModel( element ) == 2147 and "Hűtő" or getElementModel(source) == 3761 and "Szekrény" or ( getElementType( element ) == "vehicle" and "Jármű" or ( getElementType( element ) == "player" and "Játékos " .. getPlayerName( element )  or "Széf" ) )
	
	if not canPickup(source, item) then
		outputChatBox("Nem tudod mozgatni ezt a tárgyat. Keress fel egy admint az F2-val/vel.", source, 255, 0, 0)
		return
	end
	
	if giveItem( element, itemID, itemValue ) then
		output(source, element, itemID, itemValue)
		exports.logs:logMessage( getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element), 17)
		mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
		
		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )
	else
		outputChatBox( "A zsebe tele van.", source, 255, 0, 0 )
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if not canAccessElement( source, element ) then
		return
	end
	
	local name = getElementModel( element ) == 2147 and "Hűtő" or getElementModel(source) == 3761 and "Szekrény" or ( getElementType( element ) == "vehicle" and "Jármű" or "Széf" )
	
	local item = getItems( element )[slot]
	if item and item[3] == index then
		if not exports.global:isPlayerAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117 ) then
			outputChatBox( "Kérlek keress fel egy admint az F2-vel ennek a tárgynak a mozgatásához.", source, 255, 0, 0 )
		elseif item[1] > 0 then
			output( element, source, item[1], item[2])
			moveItem( element, source, slot )
			exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
		elseif item[1] == -100 then
			local armor = math.max( 0, ( ( getElementData( source, "faction" ) == 1 or ( getElementData( source, "faction" ) == 3 and ( getElementData( source, "factionrank" ) == 4 or getElementData( source, "factionrank" ) == 5 or getElementData( source, "factionrank" ) == 13 ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )
			
			if armor == 0 then
				outputChatBox( "Nem tudsz több kevlárt viselni.", source, 255, 0, 0 )
			else
				output( element, source, item[1])
				takeItemFromSlot( element, slot )
				
				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end
				
				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ), 17)
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1])
			if ammo < item[2] then
				exports.global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ), 17)
			else
				exports.global:giveWeapon( source, -item[1], item[2] )
				exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	elseif item then
		outputDebugString( "Index probléma(it-sys/s_mov_ite.lua/256): " .. tostring( item[3] ) .. " " .. tostring( index ) )
	end
	triggerClientEvent( source, "finishItemMove", source )
end

addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )
