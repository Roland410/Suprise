local marker = createMarker( 1725.6386, -1130.8886, 24.0859,"arrow", 3.0, 0, 198, 0, 150)
local marker2 = createMarker( 1737.7900390625, -1115.19921875, 24.078125,"arrow", 3.0, 0, 0, 0, 150)
local lastTick 
local timer

local rablok = {}
function rablas(thePlayer)
    local penzTimer = rablok[ thePlayer ]
	
    if penzTimer then
        outputChatBox("Befejezted a rablást. Futás!!!", thePlayer, 0, 250, 0)
        setPedAnimation( thePlayer, nil, nil )
        killTimer( penzTimer  )
        rablok[ thePlayer ] = nil
        elseif isElementWithinMarker( thePlayer, marker )  then
            local rendorok = {}
            for i, v in ipairs ( getElementsByType ( "player" ) ) do
                local theTeam = getPlayerTeam ( v )
                if theTeam then
                   local factionType = getElementData(theTeam, "type")
                    if (factionType==2) or (factionType==20) or (factionType==21)then
                        table.insert ( rendorok, v )
                    end
                end
            end
            if #rendorok < 8 then
               outputChatBox ( "((Nincs elég rendőr! Minimum:8, Jelenleg Online:"..#rendorok.."))", thePlayer, 255, 0, 0 ) 
               return
            end			
            if tonumber ( lastTick ) and getTickCount () - lastTick < 7200000 then
                outputChatBox ( "Még ".. toint((7200000-(getTickCount () - lastTick))/60000).." percet kell várnod, hogy újra rabolni tudj!", thePlayer, 255, 0, 0 ) 
                return
            end
                
            if not timer then
                timer = setTimer ( 
                    function ()
                        lastTick = getTickCount ()
                        timer = nil
                    end, 10000, 1 )
            end
        
                for i, v in ipairs( rendorok ) do
                    outputChatBox("Figyelem! Bankrablás van folyamatban!!!"  ,v,0,255,0)
                end
                exports.global:sendLocalMeAction(thePlayer, " kipakolja a páncéltermet!")
                outputChatBox("Elkezdte a pénzt pakolni a zsákjába! A rendőrök valószínűleg már úton vannak!", thePlayer, 0, 255, 0)    
				setPedAnimation ( thePlayer, "ROB_BANK", "CAT_Safe_Rob", -1, true, false, false, false)
                rablok[ thePlayer ] = setTimer(
                function( thePlayer, m )
					daBlockz = getElementData(root,"blockz")
					if isElementWithinMarker ( thePlayer, m ) then
						setPedAnimation ( thePlayer, "ROB_BANK", "CAT_Safe_Rob", -1, true, false, false, false)
						exports.global:giveMoney(thePlayer, math.random( 6000,12000 ) )
					else
						rablas ( thePlayer )
					end                        
				end, 5000, 300, thePlayer, marker  )
        end
    end
addCommandHandler("rob", rablas )
    
function rablasvege( )
    rablas ( source )
end
addEventHandler("onPlayerWasted", root, rablasvege)
function toint(n)
	local s = tostring(n)
	local i, j = s:find('%.')
	if i then
		return tonumber(s:sub(1, i-1))
	else
		return n
	end
end

function kamera()
	if isElementWithinMarker ( thePlayer, marker2 ) then
		local rendorok = {}
				for i, v in ipairs ( getElementsByType ( "player" ) ) do
					local theTeam = getPlayerTeam ( v )
					if theTeam then
					   local factionType = getElementData(theTeam, "type")
						if (factionType==2) or (factionType==20) or (factionType==21)then
							table.insert ( rendorok, v )
						end
					end
				end
		for i, v in ipairs( rendorok ) do
                    outputChatBox("Figyelem! Valaki lement a széfhez!!!"  ,v,0,255,0)
		end
	end
end