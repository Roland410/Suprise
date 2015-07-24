local pdgates = 
{
    {
		{ createObject ( 1495, 1794.04517, -1524.3571, 5699.42773 ), -90 },
		{ createObject ( 1495, 1797.02527, -1524.32910, 5699.42773, 0.00000, 0.00000, 180.00000 ), 90 }
	},
	 
}

for _, group in pairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 15)
		setElementDimension(gate[1], 1)--10583
	end
end

local function resetBusy( shortestID )
	pdgates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	group = pdgates[ shortestID ]
	for _, gate in ipairs(group) do
		local nx, ny, nz = getElementPosition( gate[1] )
		moveObject( gate[1], 1000, nx + ( gate[3] and -gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or -gate[2] )
	end
	group.busy = true
	group.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )
end

local function openDoor(thePlayer)
	if getElementDimension(thePlayer) == 1 and getElementInterior(thePlayer) == 15 and exports.global:hasItem(thePlayer, 64) then
		local shortest, shortestID, dist = nil, nil, 5
		local px, py, pz = getElementPosition(thePlayer)
		
		for id, group in pairs(pdgates) do
			for _, gate in ipairs(group) do
				local d = getDistanceBetweenPoints3D(px,py,pz,getElementPosition(gate[1]))
				if d < dist then
					shortest = group
					shortestID = id
					dist = d
				end
			end
		end
		
		if shortest then
			if shortest.busy then
				return
			elseif shortest.timer then
				killTimer( shortest.timer )
				shortest.timer = nil
				outputChatBox( "Az ajtó már nyitva van!", thePlayer, 0, 255, 0 )
			else
				for _, gate in ipairs(shortest) do
					local nx, ny, nz = getElementPosition( gate[1] )
					moveObject( gate[1], 1000, nx + ( gate[3] and gate[2] or 0 ), ny, nz, 0, 0, gate[3] and 0 or gate[2] )
				end
				outputChatBox( "Kinyitottad az ajtót!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 5000, 1, shortestID )
		end
	end
end
addCommandHandler( "nyit", openDoor)
--[[
local function teszt(thePlayer)
	setElementDimension ( thePlayer, 1 )
	setElementInterior(thePlayer, 10 )
end
addCommandHandler( "tesztcmd", teszt) ]]--
