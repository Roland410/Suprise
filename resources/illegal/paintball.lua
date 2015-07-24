

local marker = createMarker(1395.98926, -1415.10034, 4087.56421,"arrow")
function paintball (jatekos)

local logged = getElementData(jatekos, "loggedin")
if (logged==1 and  isElementWithinMarker ( jatekos, marker )) then
outputChatBox ("FLYMTA: Bekerültél a harcmezőre kérj az eladótól fegyvereket",jatekos, 0, 250, 0, false)
    local theSkin = getPedSkin(jatekos)
    local theTeam = getPlayerTeam(jatekos) 
    spawnPlayer(jatekos, 1317.2324, -1363.8378, 4094.2258,134,theSkin, 0, 0, theTeam)
	setElementDimension(jatekos,763 )
    setElementInterior(jatekos, 11 ) 

  else
  outputChatBox ("FLYMTA: Nem vagy Paintball pályán" ,jatekos, 0, 250, 240, false)
  
  end
  
 end
addCommandHandler("paintball", paintball)


function paintBallvege (jatekos)
    if getElementDimension(jatekos) == 763 then
    local theSkin = getPedSkin(jatekos)
    local theTeam = getPlayerTeam(jatekos) 
    spawnPlayer(jatekos, 1395.98926, -1415.10034, 4087.56421,134,theSkin, 0, 0, theTeam)
	setElementDimension(jatekos,763 )
    setElementInterior(jatekos, 11 )
	exports.global:takeItem(jatekos, 115)
	exports.global:takeItem(jatekos, 116)
	exports.global:takeItem(jatekos, 115)
	exports.global:takeItem(jatekos, 116)
	exports.global:takeItem(jatekos, 115)
	exports.global:takeItem(jatekos, 116)
	exports.global:takeItem(jatekos, 115)
	exports.global:takeItem(jatekos, 116)
	exports['shop-system']:hideGeneralshopUI()
    outputChatBox ( "FLYMTA: Befejezted a Paintball játékot,reméljük jólérezted magad :)",jatekos, 0, 250, 0, false)  --tell the players why they lost their weapons
  else
  outputChatBox ("FLYMTA: Nem vagy Paintball pályán" ,jatekos, 0, 250, 240, false)
  
  end
	end
addCommandHandler("paintballvége", paintBallvege)