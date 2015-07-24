mysql = exports.mysql

local peds = { }

local currentcycle = 1

local dancingcycles = 
{
	{
		{ "DANCING", "DAN_Down_A" },
		{ "DANCING", "DAN_Loop_A" },
		{ "DANCING", "DAN_Right_A" },
		{ "DANCING", "dnce_M_d" }
	},
	{
		{ "STRIP", "STR_Loop_C" },
		{ "STRIP", "strip_D" },
		{ "STRIP", "Strip_Loop_B" },
		{ "STRIP", "STR_C2" }
	}
}

addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		local result = mysql:query("SELECT id, x, y, z, rotation, skin, type, interior, dimension, offset FROM dancers" )
		local continue = true
		while continue do
			local row = mysql:fetch_assoc(result)
			if not row then break end
			
			local id = tonumber( row["id"] )
			local x = tonumber( row["x"] )
			local y = tonumber( row["y"] )
			local z = tonumber( row["z"] )
			local rotation = tonumber( row["rotation"] )
			local skin = tonumber( row["skin"] )
			local type = tonumber( row["type"] )
			local interior = tonumber( row["interior"] )
			local dimension = tonumber( row["dimension"] )
			local offset = tonumber( row["offset"] )
			
			local ped = createPed( skin, x, y, z )
			exports['anticheat-system']:changeProtectedElementDataEx( ped, "dbid", id, false )
			exports['anticheat-system']:changeProtectedElementDataEx( ped, "position", { x, y, z, rotation }, false )
			setPedRotation( ped, rotation )
			setElementInterior( ped, interior )
			setElementDimension( ped, dimension )
			
			peds[ ped ] = { type, offset }
		end
		mysql:free_result( result )
		
		setTimer( updateDancing, 50, 1 )
		setTimer( updateDancing, 12000, 0 )
	end
)

addCommandHandler( "adddancer", 
	function( thePlayer, commandName, type, skin, offset )
		if exports.global:isPlayerLeadAdmin( thePlayer ) then
			type = math.floor( tonumber( type ) or 0 )
			skin = math.floor( tonumber( skin ) or -1 )
			offset = math.floor( tonumber( offset ) or -1 )
			if not type or not skin or type < 1 or type > 2 or offset < 0 or offset > 3 then
				outputChatBox( "Használat: /" .. commandName .. " [1=Táncos, 2=Sztriptíz táncos] [Skin ID] [Táncstílus 0-3]", thePlayer, 255, 194, 14 )
			else
				local x, y, z = getElementPosition( thePlayer )
				local rotation = getPedRotation( thePlayer )
				local interior = getElementInterior( thePlayer )
				local dimension = getElementDimension( thePlayer )
				
				local query = mysql:query_fetch_assoc("SELECT COUNT(*) as number FROM dancers WHERE dimension = " .. mysql:escape_string(dimension) )
				if query then
					local num = tonumber( query["number"] ) or 5
					if dimension == 0 or num < 3 or exports.global:isPlayerScripter( thePlayer ) then
						local ped = createPed( skin, x, y, z )
						if ped then
							local id = mysql:query_insert_free("INSERT INTO dancers (x,y,z,rotation,skin,type,interior,dimension,offset) VALUES (" .. mysql:escape_string(x) .. "," .. mysql:escape_string(y) .. "," .. mysql:escape_string(z) .. "," .. mysql:escape_string(rotation) .. "," .. mysql:escape_string(skin) .. "," .. mysql:escape_string(type) .. "," .. mysql:escape_string(interior) .. "," .. mysql:escape_string(dimension) .. "," .. mysql:escape_string(offset) .. ")" )
							if id then
								exports['anticheat-system']:changeProtectedElementDataEx( ped, "dbid", id, false )
								exports['anticheat-system']:changeProtectedElementDataEx( ped, "position", { x, y, z, rotation }, false )
								setPedRotation( ped, rotation )
								setElementInterior( ped, interior )
								setElementDimension( ped, dimension )
								
								peds[ ped ] = { type, offset }
								setTimer( updateDancing, 50, 1 )
								
								outputChatBox( "Leraktál egy táncost, ID " .. id .. ".", thePlayer, 0, 255, 0 )
							else
								destroyElement( ped )
								outputDebugString( "SQL hiba /adddancer" )
								outputChatBox( "SQL hiba(Alpha).", thePlayer, 255, 0, 0 )
							end
						else
							outputChatBox( "Hibás skin ID.", thePlayer, 255, 0, 0 )
						end
					else
						outputChatBox( "Legfeljebb 3 táncos lehet egy interiorban.", thePlayer, 255, 0, 0 )
					end
				else
					outputDebugString( "SQL hiba /adddancer" )
					outputChatBox( "SQL hiba(Beta).", thePlayer, 255, 0, 0 )
				end
			end
		end
	end
)

addCommandHandler( "nearbydancers", 
	function( thePlayer )
		if exports.global:isPlayerAdmin( thePlayer ) then
			outputChatBox( "Közeli táncosok:",thePlayer, 255, 126, 0 )
			local counter = 0
			for key, value in ipairs( exports.global:getNearbyElements( thePlayer, "ped" ) ) do
				if peds[ value ] then
					outputChatBox( "   Táncos: ID " .. getElementData( value, "dbid" ) .. ", Típus " .. peds[ value ][ 1 ] .. ", Skin " .. getElementModel( value ) .. ", Táncstílus: " .. peds[ value ][ 2 ], thePlayer, 255, 126, 0 )
					counter = counter + 1
				end
			end
			
			if counter == 0 then
				outputChatBox( "   Nincs.", thePlayer, 255, 126, 0 )
			end
		end
	end
)

addCommandHandler( "deldancer",
	function( thePlayer, commandName, id )
		if exports.global:isPlayerLeadAdmin( thePlayer ) then
			id = tonumber( id )
			if not id then
				outputChatBox( "Használat: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
			else
				for ped in pairs( peds ) do
					if getElementData( ped, "dbid" ) == tonumber( id ) then
						mysql:query_free("DELETE FROM dancers WHERE id = " .. mysql:escape_string(id) )
						
						destroyElement( ped )
						
						peds[ ped ] = nil
						outputChatBox( "Táncos törölve.", thePlayer, 0, 255, 0 )
						return
					end
				end
				outputChatBox( "Nincsen táncos ezzel az ID-vel.", thePlayer, 255, 0, 0 )
			end
		end
	end
)

function updateDancing( )
	currentcycle = currentcycle + 1
	if currentcycle > 4 then
		currentcycle = 1
	end
	
	for ped, options in pairs( peds ) do
		if isElement( ped ) then
		    local pos = getElementData( ped, "position" )
			setElementPosition( ped, pos[1], pos[2],pos[3] )
			local type, offset = unpack( options )
			local animid = ( currentcycle + offset ) % 4 + 1
			setPedAnimation( ped, dancingcycles[ type ][ animid ][ 1 ], dancingcycles[ type ][ animid ][ 2 ], -1, true, false, false )
		else
			peds[ ped ] = nil
		end
	end
end

addEventHandler("onPedWasted", getResourceRootElement(),
	function()
		peds[ source ] = nil
			
		local x, y, z, rotation = unpack( getElementData( source, "position" ) )
		local newped = createPed( getElementModel( source ), x, y, z )
		setPedRotation( newped, rotation )
		exports['anticheat-system']:changeProtectedElementDataEx( newped, "dbid", getElementData( source, "dbid" ), false )
		exports['anticheat-system']:changeProtectedElementDataEx( newped, "position", getElementData( source, "position" ), false )
		
		peds[ newped ] = options
		setElementInterior( newped, getElementInterior( source ) )
		setElementDimension( newped, getElementInterior( source ) )
		
		destroyElement( source )
		
		currentcycle = currentcycle - 1
		updateDancing( )
	end
)

addCommandHandler( "updatedancers",
	function( thePlayer )
		if exports.global:isPlayerAdmin( thePlayer ) then
			updateDancing( )
		end
	end
)