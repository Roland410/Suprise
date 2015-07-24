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
	---ls épületek
	oktato = engineLoadTXD("epuletek/oktato.txd") --korhaz
    engineImportTXD(oktato, 5040 )
	vasut = engineLoadTXD("epuletek/vasut.txd") --korhaz
    engineImportTXD(vasut, 5033 )
	mec2 = engineLoadTXD("epuletek/mec2.txd") --korhaz
    engineImportTXD(mec2, 6257 )
	mec = engineLoadTXD("epuletek/mec.txd") --korhaz
    engineImportTXD(mec, 6010 )
	mec1 = engineLoadTXD("epuletek/mec1.txd") --korhaz
    engineImportTXD(mec1, 5742 )
	kut = engineLoadTXD("epuletek/kut.txd") --korhaz
    engineImportTXD(kut, 1676 )
	stad = engineLoadTXD("epuletek/stad.txd") --korhaz
    engineImportTXD(stad, 17511)
	kut1 = engineLoadTXD("epuletek/kut1.txd") --korhaz
    engineImportTXD(kut1, 5409)
	autoker = engineLoadTXD("epuletek/autoker.txd") --korhaz
    engineImportTXD(autoker, 6337 ) 
	korhaz = engineLoadTXD("epuletek/korhaz.txd") --korhaz
    engineImportTXD(korhaz, 5708 ) 
    nav = engineLoadTXD("epuletek/nav.txd") --erstebank
    engineImportTXD(nav, 6490 ) 
	szerelo2 = engineLoadTXD("epuletek/tabla.txd") 
    engineImportTXD(szerelo2, 2789 )
end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)