local count = 0
local pFish = nil
local state = 0
local fishSize = 0
local hotSpot1 = nil
local hotSpot2 = nil
local totalCatch = 0
local fishingBlip, fishingMarker, fishingCol = nil

local function showFishMarker(msg)
	if not (fishingBlip) then -- If the /sellfish marker isnt already being shown...
		fishingBlip = createBlip(81.225586, -2054.8271484375,0.283609, 0, 2, 255, 0, 255, 255 )
		fishingMarker = createMarker(81.225586, -1824.713867, 0.283609, "cylinder", 2, 255, 0, 255, 150 )
		fishingCol = createColSphere (81.225586,-1824.713867, 0.283609, 3)
		if msg == 1 then
			outputChatBox("#FF9933Készen álsz a horgászásra #FF66CC Hal értékesités #FF9933.", 255, 104, 91, true)
			outputChatBox("#FF9933((/totalcatch  Ezzel a parancsal tudod nézni mennyi halat fogtál.  /sellfish Ezzel a parancsal tudod eladni a #FF66Halpiacon#FF9933.))", 255, 104, 91, true)
		elseif msg == 2 then
			outputChatBox("#FF9933 Megteltél " .. totalCatch .. " Megvan a megfelelő halmennyiség. Menjél a halpiacra és add el", 255, 104, 91, true)
		end
	end
end

function castLine(oldcatch)

	local element = getPedContactElement(getLocalPlayer()) or getElementAttachedTo(getLocalPlayer())
	if not (isElement(element)) then
		outputChatBox("A horgászat elkezdéséhez  a hajón kell lenned.", 255, 0, 0)
	else
		if not (getElementType(element)=="vehicle") then
			outputChatBox("A horgászat elkezdéséhez  a hajón kell lenned.", 255, 0, 0)
		else
			if not (getVehicleType(element)=="Boat") then
				outputChatBox("A horgászat elkezdéséhez  a hajón kell lenned..", 255, 0, 0)
			else
				local x, y, z = getElementPosition(getLocalPlayer())
				if ((y < 3000) and ( y > -3000)) and ((x > -3000) and (x < 3000)) then -- Are they out at sea.
					outputChatBox("Menjél ki a tengerre horgászni", 255, 0, 0)
				else
					if (catchTimer) then -- Are they already fishing?
						outputChatBox("A horgászbotod bedobtad , várj amig kapásod nem lessz", 255, 0, 0)
					else
						totalCatch = oldcatch
						if (totalCatch >= 2000) then
							outputChatBox("#FF9933Ennyi hal nem fér el. #FF66CCSell#FF9933 Menny a halpiacra add el ! ", 255, 104, 91, true)
							showFishMarker()
						else
							local biteTimer = math.random(30000,300000) -- 30 seconds to 5 minutes for a bite.
							catchTimer = setTimer( fishOnLine, biteTimer, 1 ) -- A fish will bite within 1 and 5 minutes.
							triggerServerEvent("castOutput", getLocalPlayer())
							showFishMarker(1)
						end
					end
				end
			end
		end
	end
end
addEvent("castLine", true)
addEventHandler("castLine", getRootElement(), castLine)

function restoreFishingJob(amount)
	totalCatch = amount
	showFishMarker(2)
end
addEvent("restoreFishingJob", true)
addEventHandler("restoreFishingJob", getLocalPlayer(), restoreFishingJob)

function fishOnLine()
	
	killTimer(catchTimer)
	catchTimer=nil
	local x, y, z = getElementPosition(getLocalPlayer())
	if ((y < 3000) and ( y > -3000)) and ((x > -3000) and (x < 3000)) then
		outputChatBox("A tengeren kellet volna maradnod ha horgászni akarsz még ! ", 255, 0, 0)
	else
		triggerServerEvent("fishOnLine", getLocalPlayer()) -- outputs /me
		
		--  the progress bar
		count = 0
		state = 0
				
		if (pFish) then
			destroyElement(pFish)
		end
			
		pFish = guiCreateProgressBar(0.425, 0.75, 0.2, 0.035, true)
		outputChatBox("Kapásod van! ((Tap [ and ] huzd ki a halat a vizből.))", 0, 255, 0)
		bindKey("+", "down", reelItIn)
		setElementData(getLocalPlayer(), "fishing", true, false)
		
		-- create two timers
		resetTimer = setTimer(resetProgress, 2750, 0)
		gotAwayTimer = setTimer(gotAway, 60000, 1)
		
		if ((x >= 3950) and (x <= 4450)) and ((y >= -2050) and (y <= -1550)) or (x >= -250) and (x <= 250) and (y >= -4103) and (y <= -3603) then
			fishSize = math.random(100, 200)
		else
			if (x > 5500) or (x < -5500) or (y > 5500) or (y < -5500) then
				fishSize = math.random(80, 105)
			elseif (x > 4500) or (x < -4500) or (y > 4500) or (y < -4500) then
				fishSize = math.random(50, 90)
			elseif (x > 3500) or (x < -3500) or (y > 3500) or (y < -3500) then
				fishSize = math.random(30,70)
			else
				fishSize = math.random(1, 50)
			end
		end
		
		local lineSnap = math.random(1,10) -- Chances of line snapping 1/10. Fish over 100lbs are twice as likely to snap your line.
		if (fishSize>=100)then
			if (lineSnap > 9) then
				outputChatBox("Egy nagyobb hal  eltérte a hirgászbotodat. Menjél a horgászboltba és vásárolj ujjat", 255, 0, 0)
				triggerServerEvent("lineSnap",getLocalPlayer())
				killTimer (resetTimer)
				killTimer (gotAwayTimer)
				destroyElement(pFish)
				pFish = nil
				unbindKey("+", "down", reelItIn)
				unbindKey("-", "down", reelItIn)
				fishSize = 0
				setElementData(getLocalPlayer(), "fishing", false, false)
			end
		end
	end
end

function reelItIn()
	if (state==0) then
		bindKey("mouse1", "down", reelItIn)
		unbindKey("mouse2", "down", reelItIn)
		state = 1
	elseif (state==1) then
		bindKey("mouse1", "down", reelItIn)
		unbindKey("mouse2", "down", reelItIn)
		state = 0
	end
	
	count = count + 1
	guiProgressBarSetProgress(pFish, count)
	
	if (count>=100) then
		killTimer (resetTimer)
		killTimer (gotAwayTimer)
		destroyElement(pFish)
		pFish = nil
		unbindKey("[", "down", reelItIn)
		unbindKey("]", "down", reelItIn)

		totalCatch = math.floor(totalCatch + fishSize)
		outputChatBox("kifogtál 1 halat"..totalCatch.."A fogott halmennyiség eddig", 255, 194, 14)
		triggerServerEvent("catchFish", getLocalPlayer(), fishSize, totalCatch)
		fishSize = 0
		
		setElementData(getLocalPlayer(), "fishing", false, false)
	end
end

function resetProgress()
	if(count>=0)then
		local difficulty = (fishSize/4)
		guiProgressBarSetProgress(pFish, (count-difficulty))
		count = count-difficulty
	else
		count = 0
	end
end

function gotAway()
	killTimer (resetTimer)
	destroyElement(pFish)
	pFish = nil
	unbindKey("[", "down", reelItIn)
	unbindKey("]", "down", reelItIn)
	outputChatBox("#FF9933A hal elmenekült.", 255, 0, 0, true)
	fishSize = 0
	setElementData(getLocalPlayer(), "fishing", false, false)
end

-- /totalcatch command
function currentCatch()
	outputChatBox("Neked van"..totalCatch.."A fogott halmennyiség eddig", 255, 194, 14)
end
addCommandHandler("totalcatch", currentCatch, false, false)

-- sellfish
function unloadCatch(thePlayer, commandName)
	if (isElementWithinColShape(getLocalPlayer(), fishingCol)) then
		if (totalCatch == 0) then
			outputChatBox("Meg kell fogni néhány halat eladni az elsö.", 255, 0, 0)
		else
			local profit = math.floor(totalCatch*0.66)
			outputChatBox("Tedd pénzé".. exports.global:formatMoney(profit) .." A fogott halmennyiség eddig", 255, 104, 91)
			triggerServerEvent("sellcatch", getLocalPlayer(), totalCatch, profit)
			destroyElement(fishingBlip)
			destroyElement(fishingMarker)
			destroyElement(fishingCol)
			fishingBlip, fishingMarker, fishingCol = nil
			
			totalCatch = 0
		end
	else
		outputChatBox("Menjél a halpiacra add el a halakat", 255, 0, 0)
	end
end
addCommandHandler("sellFish", unloadCatch, false, false)
