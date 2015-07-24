
function applyMods()
    stoptabla = engineLoadTXD("stoptabla.txd", 3334) --stoptabla
    engineImportTXD(stoptabla, 3334)
	stoptabla = engineLoadDFF("stoptabla.dff", 3334) --stoptabla
    engineReplaceModel(stoptabla, 3334)
	elsobtabla = engineLoadTXD("elsobtabla.txd", 3262) --stoptabla
    engineImportTXD(elsobtabla, 3262)
	elsobtabla = engineLoadDFF("elsobtabla.dff", 3262) --stoptabla
    engineReplaceModel(elsobtabla, 3262)
	otven = engineLoadTXD("otven.txd", 1322) --stoptabla
    engineImportTXD(otven, 1322)
	otven = engineLoadDFF("otven.dff", 1322) --stoptabla
    engineReplaceModel(otven, 1322)
	fout = engineLoadTXD("fout.txd", 3263) --stoptabla
    engineImportTXD(fout, 3263)
	fout = engineLoadDFF("fout.dff", 3263) --stoptabla
    engineReplaceModel(fout, 3263)
	harminc = engineLoadTXD("harminc.txd", 2599) --stoptabla
    engineImportTXD(harminc, 2599)
	harminc = engineLoadDFF("otven.dff", 2599) --stoptabla
    engineReplaceModel(harminc, 2599)
	kilenc = engineLoadTXD("kilenc.txd", 1321) --stoptabla
    engineImportTXD(kilenc, 1321)
	kilenc = engineLoadDFF("otven.dff", 1321) --stoptabla
    engineReplaceModel(kilenc, 1321)
	szaz = engineLoadTXD("szaz.txd", 3264) --stoptabla
    engineImportTXD(szaz, 3264)
	szaz = engineLoadDFF("otven.dff", 3264) --stoptabla
    engineReplaceModel(szaz, 3264)
	apalya = engineLoadTXD("apalya.txd", 3380) --stoptabla
    engineImportTXD(apalya, 3380)
	apalya = engineLoadDFF("otven.dff", 3380) --stoptabla
    engineReplaceModel(apalya, 3380)
	

end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)