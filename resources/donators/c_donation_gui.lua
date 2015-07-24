local wDonation,lSpendText,bClose,penz,f7state = nil
function openDonationGUI (obtained, available, credits)

  if wDonation ~= nil then
		return false
	end
	
	wDonation = guiCreateWindow(0.10, 0.18, 0.8, 0.7, "Prémium Pont elköltése", true)
	guiWindowSetSizable(wDonation, false)
	
	lSpendText = guiCreateLabel(0.015, 0.05, 0.5, 0.15, "Prémium Pontok: " .. tostring(credits) .." PP", true, wDonation)
	guiSetFont(lSpendText, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.015, 0.15, 0.5, 0.15, "Alapcsomag:(100 PP) ", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.015, 0.19, 0.5, 0.15, "Támogató ikon ts-en", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.015, 0.23, 0.5, 0.15, "Pénz: 250.000 Fly Forint", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
    lAvailable = guiCreateLabel(0.20, 0.15, 0.5, 0.15, "Bronz:(400 PP) ", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.20, 0.19, 0.5, 0.15, "Támogató ikon ts-en", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.20, 0.23, 0.5, 0.15, "Pénz: 500.000 Fly Forint", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.20, 0.27, 0.5, 0.15, "Fegyver:Colt 100,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	 lAvailable = guiCreateLabel(0.40, 0.15, 0.5, 0.15, "Ezüst:(1000 PP) ", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.40, 0.19, 0.5, 0.15, "Támogató ikon ts-en", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.40, 0.23, 0.5, 0.15, "Pénz: 500.000 Fly Forint", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.40, 0.27, 0.5, 0.15, "Fegyver:Colt 100,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.40, 0.31, 0.5, 0.15, "Fegyver:M4 200,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	 lAvailable = guiCreateLabel(0.60, 0.15, 0.5, 0.15, "Arany:(2400 PP) ", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.19, 0.5, 0.15, "Támogató ikon ts-en", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.23, 0.5, 0.15, "Pénz: 1.000.000 Fly Forint", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.27, 0.5, 0.15, "Fegyver:Colt 100,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.31, 0.5, 0.15, "Fegyver:M4 200,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.35, 0.5, 0.15, "Fegyver:MP5 200,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.60, 0.40, 0.5, 0.15, "Forum támogató rang", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	 lAvailable = guiCreateLabel(0.80, 0.15, 0.5, 0.15, "Gyémánt:(5000 PP) ", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.19, 0.5, 0.15, "Támogató ikon ts-en", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.23, 0.5, 0.15, "Pénz: 2.000.000 Fly Forint", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.27, 0.5, 0.15, "Fegyver:Colt 100,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.31, 0.5, 0.15, "Fegyver:M4 200,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.35, 0.5, 0.15, "Fegyver:MP5 200,golyó", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.40, 0.5, 0.15, "Teamspeak3 Vip szoba", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	lAvailable = guiCreateLabel(0.80, 0.45, 0.5, 0.15, "Forum támogató rang", true, wDonation)
	guiSetFont(lAvailable, "default-bold-small")
	
	bClose = guiCreateButton(0.5, 0.05, 0.5, 0.075, "Bezár", true, wDonation)
	addEventHandler("onClientGUIClick", bClose, closeDonationGUI)
	
	f7state = getKeyState( "f7" )
	addEventHandler("onClientRender", getRootElement(), checkF7)
end
addEvent("donation-system:GUI:open", true)
addEventHandler("donation-system:GUI:open", getRootElement(), openDonationGUI)

function closeDonationGUI()
	if (wDonation) then
		destroyElement(wDonation)
		wDonation,lSpendText,lActive,lAvailable,bClose  = nil
		lItems = {}
		bItems = { }
		guiSetInputEnabled(false)
		removeEventHandler("onClientRender", getRootElement(), checkF7)
		triggerServerEvent("donation-system:GUI:close", getLocalPlayer())
	end
	
	hidePhonePicker()
end

function penzbevalt()
	if (wDonation) then
		destroyElement(wDonation)
		wDonation,lSpendText,lActive,lAvailable,bClose  = nil
		guiSetInputEnabled(false)
		removeEventHandler("onClientRender", getRootElement(), checkF7)
		triggerServerEvent("premiumpenz", getLocalPlayer())
	end

end

--

