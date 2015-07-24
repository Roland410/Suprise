local myadminWindow = nil

function gmhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerGameMaster(sourcePlayer) or exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Admin/Segéd Parancsok", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 8 do 
				local tab = guiCreateTab("Szint " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Parancs", 0.15)
				guiGridListAddColumn (lists[level], "Használat", 0.35)
				guiGridListAddColumn (lists[level], "Példa", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Close", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level -1: Trainee GM
				{
					-- adminsegéd
				{ "/recon", "/recon [player]", "Játékost figyeled meg" },
				{ "/fuckrecon", "/stoprecon", "Játékos megfigyelését kapcsolod ki" },
				{ "/goto", "/goto [player]", "Teleportálás a játékoshoz" },
				{ "/a", "/a", "Adminokkal tudsz beszélni" },
				{ "/vá", "/vá", "Pmre Tudsz válaszolni" },
				{ "/aduty", "/aduty", "Szolgálat be/ki" },
				{ "/asay", "/asay", "Felhivás" },
				{ "/nevek", "/nevek", "neveket kapcsolod be" },
				{ "/gethere", "/gethere [player]", "Magadhoz teleportálod a játékost" },
				{ "/jailed", "/jailed", "Ezzel tudod megnézni kik vannak jailban" }
				},
				-- level 1 admin
				{
				{ "/jail", "/jail [player] [minutes] [reason]", "Adminbörtönbe zárod vele a játékost" },
				{ "/unjail", "/ujail [player] [minutes] [reason]", "Adminbörtönből kiveszed vele a játékost" },
				{ "/freeze", "/freeze [player]", "Játékos fagyasztása" },
				{ "/sethp", "/sethp [player] [new hp]", "Játékosnak adsz vele életet" },
				{ "/unfreeze", "/unfreeze [player]", "Játékos kiolvasztása" },
				{ "/slap", "/slap [player]", "Pacsizod a játékost" },
				
				{ "/pkick", "/pkick [player] [reason]", "Játékos kirugása" },
				{ "/respawnveh", "/respawnveh [id]", "Respawnolod a kocsit vele" },
				{ "/respawnciv", "/respawnciv", "Csak a civil kocsit respawnolod vele" },
				{ "/pban", "/pban [player] [hours] [reason]", "Játékos bannolása" },
				{ "/getcar", "/getcar [id]", "magadhoz hivod a kocsit" },
				
				

					
				},
				-- level 2 admin
				{
				{ "/auncuff", "/auncuff [player]", "Bilincset veszed le" },
				{ "/aunmask", "/aunmask [player]", "maszkot veszed le" },
				{ "/freconnect", "/freconnect [player]", "Játékosújracsatlakoztatása" },
				{ "/setskin", "/setskin [player] [skin id]", "Játékosnak a skinét változtatod meg" },
				{ "/setlanguage", "/setlanguage [player] [language] [skill]", "Játékos nyelvét állitod át" },
				{ "/dellanguage", "/dellanguage [player] [language]", "Játékos nyelvét törlöd" },
				{ "/fuelveh", "/fuelveh [player]", "Kocsi megtankolása" },
				{ "/fuelvehs", "/fuelvehs", "összes kocsi megtankolása" },
				{ "/setcolor", "/setcolor [player] [colors...]", "Játékos kocsijának a szine modositása" },
				{ "/getcolor", "/getcolor [car]", "Visszaadja a kocsi szinét" },
				{ "/gotocar", "/gotocar [id]", "Odateleportálsz a kocsihoz" },
				
				
				
				
				},
				{ -- level 3 admin
				{ "/veh", "/veh [model] [color 1] [color 2]", "Kocsilekérés" },
				{ "/oldcar", "/oldcar", "Utolsó jármű idje amiben ültél" },
				{ "/respawnall", "/respawnall", "összes kocsi respawnolása" },
				{ "/entercar", "/entercar [player] [car] [seat]", "Kocsiba teleportálás" },
				{ "/fixvehis", "/fixvehis [player]", "Rögziti a jármúvek megjelenését, a motor marad törve" },
				{ "/getpos", "/getpos", "ki irja a poziciodat" },
				{ "/blowveh", "/blowveh [player]", "blows up a players car" },
			    { "/setcarhp", "/setcarhp [player]", "sets the health of a car, full health is 1000." },
				{ "/thiscar", "/thiscar", "Jelenlegi autó id-je" },
				{ "/findveh", "/findveh [name]", "Kocsi keresés" },
				
				
				},
				{ -- level 4 admin
				{ "/unlockcivcars", "/unlockcivcars", "Ezzel nyitod ki a játékosnak a kocsiját" },
				{ "/unflip", "/unflip", "Ezzel állitod helyre a kocsid ha fejtetön van" },
				{ "/disarm", "/disarm [player]", "Fegyver elvétel a playertől" },
				{ "/pmute", "/pmute [player]", "Játékos némitása" },
				{ "/takeitem", "/takeitem [player] [", "Elveszed a player cuccait akkor is ha offline a player" },
				{ "/névváltás", "/névváltás [id]", "Átirod a player nevét" },
				
				},
				-- level főadmin
			{ 
			    { "/nearbyinteriors", "/nearbyinteriors","Megmutassa az interiorokat" },
				{ "/gotohouse", "/gotohouse [id]", "Teleportálás a házhoz" },
				{ "/setinteriorid", "/setinteriorid [id]","Interior lecserélése másikra" },
				{ "/setinteriorprice", "/setinteriorprice [price]","Interior belépés árának modositása" },
				{ "/getinteriorprice", "/getinteriorprice","Interior árak megmutatása" },
				{ "/setinteriortype", "/setinteriortype [type]","Interior tipusának lecserélése" },
				{ "/getinteriorid", "/getinteriorid [id]","Interiorba telézel" },
				{ "/toggleinterior", "/toggleinterior [id]","készletek belső engedélyezett vagy tiltott" },
				{ "/reloadinterior", "/reloadinterior [id]","Adatbázisból tölti ujra az interiorokat" },
				{ "/addinterior", "/addinterior  [Interior ID] [TYPE] [Cost] [Name]","Létrehozol egy interiort" },
				{ "/delinterior", "/delproperty","Törlöd az interiort" },
				{ "/setinteriorentrance", "/setinteriorentrance  [Interior ID]","megváltoztatja egy belső bejárati helyét" },
				{ "/setinteriorname", "/setinteriorname [newname]","Interior átnevezése" },
				{ "/setfee", "/setfee [amount]","Beállitja az interiorba lépés árát" },
				{ "/agl", "/agivelicense [player] [type]", "Játékosnak engedélyeket adsz" },
                { "/atakelicense", "/atakelicense [player] [type]", "Elveszed a player engedéyeit akkor is ha offline a player" },
				{ "/unban", "/unban [full char name]", "Játékos unbannolása" },
				{ "/setfactionleader", "/setfactionleader [player] [factionid]", "Frakcioleadert adsz neki" },
				{ "/setfactionrank", "/setfactionrank [player] [rank]", "Frakciórangot adsz neki" },
				{ "/fixveh", "/fixveh [player]", "Kocsi megjavitása" },
				{ "/setvehiclefaction", "/setvehiclefaction [vehicleid] [factionid]", "megváltoztatja a gépjármű tulajdonosának a frakciót" },
				{ "/fixvehs", "/fixvehs", "összes kocsi megjavitása" }
				
				
			},
			{ ---scripter
			    { "/addatm", "/addatm", "Atm-et teszel le ig" },
				{ "/delatm", "/delatm [id]", "Törlöd a lerakott atm-eket" },
				{ "/nearbyatms", "/nearbyatms", "mutatja a közeli ATM-eket" },
				{ "/delveh", "/delveh [id]", "Kocsi tőrlése véglegesen" },
				{ "/delthisveh", "/delthisveh", "összeskocsi törlése" },
				{ "/makeveh", "/makeveh", "Kocsi játékosra való iratás" },
				{ "/setvehicleplate", "/setvehicleplate [carid] [plate text]", "Rendszámtáblát cseréled le" },
				{ "/setvehtint", "/setvehtint [player] [0- Remove, 1- Add]", "Eltünteted a kocsi festését" }
			},
			{ ---Tulajdonos
			{ "/setmoney", "/setmoney [player] [money]", "Játékosnak adsz vele pénzt,Visszaéllsz vele bann" },
		    { "/givemoney", "/givemoney [player] [money]", "Játékosnak adsz vele pénzt,Visszaéllsz vele bann" },
			{ "/setvehlimit", "/setvehlimit [player] [limit]", "Játékos max kocsi limitjét állitod vele" },
			{ "/setcarhp", "/setcarhp [player]", "sets the health of a car, full health is 1000." },
			{ "/makeadmin", "/makeadmin [player] [rank]", "Admint nevezel ki vele" },
			{ "/makegun", "/makegun", "Játékosnak adsz vele fegyvert,Visszaéllsz vele bann" },
			{ "/makeammo", "/makeammo", "Játékosnak adsz vele töltényt,Visszaéllsz vele bann" },
			{ "/giveitem", "/giveitem [player] [item id] [item value]", "ad a játékosnak a megadott elemet, lásd: / itemlist" },
			{ "/ujmodell", "/ujmodell", "/ujmodell kocsi id kocsi modell id" },
			{ "/delveh", "/delveh [id]", "Kocsi tőrlése véglegesen" },
			{ "/delthisveh", "/delthisveh", "összeskocsi törlése" },
			{ "/startres", "/startres [resource name]", "Mappákat inditod vele" },
			{ "/stopres", "/stopres [resource name]", "Mappákat állitod le vele" },
			{ "/restartres", "/restartres [resource name]", "Mappák ujrainditása" },
			{ "/rcs", "/rcs", "Erőforrás-Keeper " },
			{ "/modell", "/modell", "" }
			
			}
			
			}
			
			for level, levelcmds in pairs( commands ) do
				if #levelcmds == 0 then
					local row = guiGridListAddRow ( lists[level] )
					guiGridListSetItemText ( lists[level], row, 1, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 2, "-", false, false)
					guiGridListSetItemText ( lists[level], row, 3, "There are currently no commands specific to this level.", false, false)
				else
					for _, command in pairs( levelcmds ) do
						local row = guiGridListAddRow ( lists[level] )
						guiGridListSetItemText ( lists[level], row, 1, command[1], false, false)
						guiGridListSetItemText ( lists[level], row, 2, command[2], false, false)
						guiGridListSetItemText ( lists[level], row, 3, command[3], false, false)
					end
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myadminWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myadminWindow = nil
					end
				end
			end, false)
			
			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myadminWindow)
			if (visible == false) then
				guiSetVisible( myadminWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("ah", gmhelp)