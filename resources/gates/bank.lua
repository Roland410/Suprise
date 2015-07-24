local marker  = createMarker( 1719.9000244141, -1130.3000488281, 24.39999961853,"arrow", 3, 255, 0, 0)
local pdgates = 
{
	{
		{ createObject(2634, 1719.9000244141, -1130.3000488281, 24.39999961853,0,0,90), 90 }
	},
	
}

for _, group in pairs(pdgates) do
	for _, gate in ipairs(group) do
		setElementInterior(gate[1], 0)
		setElementDimension(gate[1], 0)
	end
end

local function resetBusy( shortestID )
	pdgates[ shortestID ].busy = nil
end

local function closeDoor( shortestID )
	group = pdgates[ shortestID ]
	for _, gate in ipairs(group) do
		local nx, ny, nz = getElementPosition( gate[1] )
		moveObject( gate[1], 1000, nx, ny, nz, 0, 0, -gate[2] )
	end
	group.busy = true
	group.timer = nil
	setTimer( resetBusy, 1000, 1, shortestID )

end

local function openDoor(thePlayer)
	if getElementDimension(thePlayer) == 0 and getElementInterior(thePlayer) == 0 and exports.global:hasItem(thePlayer, 122) then
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
					moveObject( gate[1], 1000, nx, ny, nz, 0, 0, gate[2] )
				end
				setPedAnimation( thePlayer, nil, nil )
				exports.global:sendLocalMeAction(thePlayer, "Sikeresen kifeszitette az ajtót.")
				triggerClientEvent("hangLejatszas", root )
				
				outputChatBox( "Sikeresen kinyitottad az ajtót! 5 perc múlva a biztonsági rendszer bezárja!", thePlayer, 0, 255, 0 )
			end
			shortest.timer = setTimer( closeDoor, 300000, 1, shortestID )
		end
	end
end


function Felfeszit (thePlayer)
  if exports.global:hasItem(thePlayer, 122) and  isElementWithinMarker ( thePlayer, marker ) then
  setPedAnimation ( thePlayer, "ROB_BANK", "CAT_Safe_Open", -1, true, false, false, false)
  setTimer(openDoor, 5000, 1, thePlayer )
  outputChatBox( "Elkezdted felfeszíteni az ajtót!", thePlayer, 0, 255, 0 )
  exports.global:sendLocalMeAction(thePlayer, "Elkezdte felfeszíteni az ajtót!")
  else
  outputChatBox( "Nem vagy a páncéteremnél/vagy nincs Feszitővasad! ", thePlayer, 255, 0, 0 )  
  end
  
 end
addCommandHandler("feszit", Felfeszit )


