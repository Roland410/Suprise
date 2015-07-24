function applyMods()
	----------------------
	-- Pig Pen Interior --
	----------------------
	--[[ Bar
	pigpen1 = engineLoadTXD("ls/lee_stripclub1.txd")
	engineImportTXD(pigpen1, 14831)
	
	-- corver stage + seat
	pigpen2 = engineLoadTXD("ls/lee_stripclub.txd")
	engineImportTXD(pigpen2, 14832)
	-- Backwall seats
	engineImportTXD(pigpen2, 14833)
	-- columns
	engineImportTXD(pigpen2, 14835)
	-- corner seats
	engineImportTXD(pigpen2, 14837)
	-- main interior structure
	engineImportTXD(pigpen2, 14838)
	]]
	-- mentő
    mento = engineLoadTXD("fskinek/mento/mento.txd", 274)
    engineImportTXD(mento, 274)
	mento = engineLoadDFF("fskinek/mento/mento.dff", 274)
    engineReplaceModel(mento, 274)
	mento1 = engineLoadTXD("fskinek/mento/mento1.txd", 275)
    engineImportTXD(mento1, 275)
	mento1 = engineLoadDFF("fskinek/mento/mento1.dff", 275)
    engineReplaceModel(mento1, 275)
	mento2 = engineLoadTXD("fskinek/mento/mento2.txd", 276)
    engineImportTXD(mento2, 276)
	mento2 = engineLoadDFF("fskinek/mento/mento2.dff", 276)
    engineReplaceModel(mento2, 276)
	----frakcio kocsik
	rendor = engineLoadTXD ("fkocsik/rendor.txd", 596 ) 
    engineImportTXD (rendor, 596 ) 
    rendor  = engineLoadDFF ("fkocsik/rendor.dff", 596 ) 
	engineReplaceModel(rendor, 596)
	mento = engineLoadTXD("fkocsik/ambulan.txd", 416) 
    engineImportTXD(mento, 416)
    mento = engineLoadDFF("fkocsik/ambulan.dff", 416) 
    engineReplaceModel(mento, 416)
	tek = engineLoadTXD("kocsik/enforcer.txd", 427 )
    engineImportTXD(tek, 427)
    tek = engineLoadDFF("kocsik/enforcer.dff", 427 )
    engineReplaceModel(tek, 427)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)