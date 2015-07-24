local myadminWindow = nil

function adminhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Adminparancsok", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 5 do 
				local tab = guiCreateTab("Szint " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Parancs", 0.15)
				guiGridListAddColumn (lists[level], "Használat", 0.35)
				guiGridListAddColumn (lists[level], "Útmutató", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Bezár", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level 1: Trial Admin
				{
					-- player/*
					{ "/adminlounge", "/adminlounge", "Nyugi a nappaliban" },
					{ "/forceapp", "/forceapp [player]", "Játékos kényszeritése az ucpre" },
					{ "/check", "/check [player]", "Játékos chekkolása" },
					{ "/stats", "/stats [player]", "Játékos adatai megnézése" },
					{ "/auncuff", "/auncuff [player]", "Bilincset veszed le" },
					{ "/pmute", "/pmute [player]", "Játékos némitása" },
					{ "/togooc", "/togooc", "Globál ooc chat ki/be kapcsolása" },
					{ "/stogooc", "/stogooc", "Globál ooc chat ki/be kapcsolása" },
					{ "/disarm", "/disarm [player]", "Fegyver elvétel a playertől" },
					{ "/freconnect", "/freconnect [player]", "Játékosújracsatlakoztatása" },
					{ "/giveitem", "/giveitem [player] [item id] [item value]", "ad a játékosnak a megadott elemet, lásd: / itemlist" },
					{ "/sethp", "/sethp [player] [new hp]", "Játékosnak adsz vele életet" },
					{ "/setarmor", "/setarmor [player] [new armor]", "Játékosnak adsz vele páncélt" },
					{ "/setskin", "/setskin [player] [skin id]", "Játékosnak a skinét változtatod meg" },
					{ "/changename", "/changename [player] [new character name]", "Játékos nevét változtatod meg" },
					{ "/slap", "/slap [player]", "Pacsizod a játékost" },
					{ "/recon", "/recon [player]", "Játékost figyeled meg" },
					{ "/fuckrecon", "/stoprecon", "Játékos megfigyelését kapcsolod ki" },
					{ "/pkick", "/pkick [player] [reason]", "Játékos kirugása" },
					{ "/pban", "/pban [player] [hours] [reason]", "Játékos bannolása" },
					{ "/unban", "/unban [full char name]", "Játékos unbannolása" },
					{ "/unbanip", "/unbanip [ip]", "Játékos unbannolása ip" },
					{ "/unbanserial", "/unbanip [serial]", "Játékos serial unbannolása" },
					{ "/gotoplace", "/gotoplace [ls/sf/lv/pc]", "Teleportálás a városokba" },
					{ "/jail", "/jail [player] [minutes] [reason]", "Adminbörtönbe zárod vele a játékost" },
					{ "/unjail", "/unjail [player]", "Adminbörtönböl veszed ki a játékost" },
					{ "/jailed", "/jailed", "Adminbörtönben akik vannak ezzel nézed meg" },
					{ "/goto", "/goto [player]", "Teleportálás a játékoshoz" },
					{ "/gethere", "/gethere [player]", "Magadhoz teleportálod a játékost" },
					{ "/sendto", "/gethere [player] [dest. player]", "Játékost teleportálsz játékoshoz" },
					{ "/freeze", "/freeze [player]", "Játékos fagyasztása" },
					{ "/unfreeze", "/unfreeze [player]", "Játékos kiolvasztása" },
					{ "/mark", "/mark [label]", "Poziciómentés" },
					{ "/gotomark", "/gotomark [label]", "Teleportálás a poziciohoz" },
					{ "/adminduty", "/adminduty", "(Adminszolgálatba állás/kilépés" },
					{ "/amotd", "/amotd", "Megmutatja az admin beszélgetést az nap" },
					{ "/warn", "/warn [player]", "Játékos figyelmeztetése 3 figyelmeztetés 3=örökbann" },
					{ "/showinv", "/showinv [player]", "Játékos invertorijénak ellenőrzése" },
					{ "/listcarprices", "/listcarprices", "Eladókocsik árjegyzéke" },

					{ "/findalts", "/findalts [player]", "megmutatja az összes karaktert " },
					{ "/findip", "/findip [player/username/ip]", "Játékos keresése" },
					{ "/findserial", "/findserial [player/username/serial]", "Játékos serila keresesése" },

					{ "/setlanguage", "/setlanguage [player] [language] [skill]", "Játékos nyelvét állitod át" },
					{ "/dellanguage", "/dellanguage [player] [language]", "Játékos nyelvét törlöd" },
					{ "/agivelicense", "/agivelicense [player] [type]", "Játékosnak engedélyeket adsz" },
					{ "/resetcontract", "/resetcontract [player]", "Törlöd a játékos kötelezö fizetéseit" },

					-- vehicle/*
					{ "/carlist", "/carlist", "Járműveket nézed meg vele" },
					{ "/unlockcivcars", "/unlockcivcars", "Ezzel nyitod ki a játékosnak a kocsiját" },
					{ "/oldcar", "/oldcar", "Utolsó jármű idje amiben ültél" },
					{ "/thiscar", "/thiscar", "Jelenlegi autó id-je" },
					{ "/gotocar", "/gotocar [id]", "Odateleportálsz a kocsihoz" },
					{ "/getcar", "/getcar [id]", "magadhoz hivod a kocsit" },
					{ "/respawnveh", "/respawnveh [id]", "Respawnolod a kocsit vele" },
					{ "/respawnall", "/respawnall", "összes kocsi respawnolása" },
					{ "/respawnciv", "/respawnciv", "Csak a civil kocsit respawnolod vele" },
					{ "/findveh", "/findveh [name]", "Kocsi keresés" },
					{ "/fixveh", "/fixveh [player]", "Kocsi megjavitása" },
					{ "/fixvehs", "/fixvehs", "összes kocsi megjavitása" },
					{ "/fixvehis", "/fixvehis [player]", "Rögziti a jármúvek megjelenését, a motor marad törve" },
					{ "/blowveh", "/blowveh [player]", "blows up a players car" },
					{ "/setcarhp", "/setcarhp [player]", "sets the health of a car, full health is 1000." },
					{ "/fuelveh", "/fuelveh [player]", "Kocsi megtankolása" },
					{ "/fuelvehs", "/fuelvehs", "összes kocsi megtankolása" },
					{ "/setcolor", "/setcolor [player] [colors...]", "Játékos kocsijának a szine modositása" },
					{ "/getcolor", "/getcolor [car]", "Visszaadja a kocsi szinét" },
					{ "/entercar", "/entercar [player] [car] [seat]", "Kocsiba teleportálás" },
					
					-- interior/*
					{ "/getpos", "/getpos", "Kiirja az ön aktuális pozicióját, és belső dimenzió" },
					{ "/reloadinterior", "/reloadinterior [id]","Adatbázisból tölti ujra az interiorokat" },
					{ "/nearbyinteriors", "/nearbyinteriors","Megmutassa az interiorokat" },
					{ "/setinteriorname", "/setinteriorname [newname]","Interior átnevezése" },
					{ "/setfee", "/setfee [amount]","Beállitja az interiorba lépés árát" },
					
					-- election/*
					{ "/addcandidate", "/addcandidate", "Add a játékos választást szavazás listához" },
					{ "/delcandidate", "/delcandidate", "Szavazási lista törlése" },
					{ "/showresults", "/showresults", "Szavazást mutatja meg" },
					
					-- factions/*
					{ "/showfactions", "/showfactions", "Megmutatja a frakciókat a szerveren" },
					
					{ "/resetbackup", "/resetbackup [name]", "Erősitést mondod le a playernek" },
					{ "/aremovespikes", "/aremovespikes", "Törli az elhagyott utzárakat" },
					{ "/restartgatekeepers", "/restartgatekeepers", "újrainditja a kapuöröket" },
					
					{ "/bury", "/bury [player]", "Eltemeti a játékost és törli a hullát" },
				
					-- advert commands
					{ "/listadverts", "/listadverts", "ad egy listát a nemrég befejezödött és folyamatban lévő hirdetésekről" },
					{ "/freeze", "/freezead [ID]", "Hirdetés megakadályozása" },
					{ "/unfreeze", "/unfreezead [ID]", "Hirdetés engedélyezése" },
					{ "/deletead", "/deletead [ID]", "Hirdetés törlése" },
				},
				-- level 2: Admin
				{
					{ "/gotohouse", "/gotohouse [id]", "Teleportálás a házhoz" },
					-- vehicles
					{ "/veh", "/veh [model] [color 1] [color 2]", "Kocsilekérés" }

					
				},
				-- level 3: Super Admin
				{
					{ "/setweather", "/setweather", "Időjárásváltoztatás" },
					
					-- vehicles
					{ "/delveh", "/delveh [id]", "Kocsi tőrlése véglegesen" },
					{ "/delthisveh", "/delthisveh", "összeskocsi törlése" },
					{ "/makeveh", "/makeveh", "Kocsi játékosra való iratás" },
					{ "/addupgrade", "/addupgrade [player] [upgrade id]", "Frissitti a játékos kocsijait" },
					{ "/setpaintjob", "/setpaintjob [player] [upgrade id]", "átfested a játékos kocsiját" },
					{ "/delupgrade", "/delupgrade [player] [upgradeid]", "Törlöd a játékos kocsijának frissitését" },
					{ "/resetupgrades", "/resetupgrades [player]", "Eltávolitod az összes tuningot a kocsirol" },
					{ "/setvehtint", "/setvehtint [player] [0- Remove, 1- Add]", "Eltünteted a kocsi festését" },
					{ "/atakelicense", "/atakelicense [player] [type]", "Elveszed a player engedéyeit akkor is ha offline a player" },
					{ "/setvehicleplate", "/setvehicleplate [carid] [plate text]", "Rendszámtáblát cseréled le" },
					{ "/setvehiclefaction", "/setvehiclefaction [vehicleid] [factionid]", "megváltoztatja a gépjármű tulajdonosának a frakciót" },
					-- elevatorssa
					{ "/addelevator", "/addelevator [interior] [dimension] [x] [y] [z]", "Liftet telepitesz" },
					{ "/delelevator", "/delelevator [id]", "Törlöd a liftet" },


					
					
				},
				-- level 4: Lead Admins
				{
					
					{ "/addatm", "/addatm", "Atm-et teszel le ig" },
					{ "/delatm", "/delatm [id]", "Törlöd a lerakott atm-eket" },
					{ "/nearbyatms", "/nearbyatms", "mutatja a közeli ATM-eket" },

					-- paynspray/*
					{ "/makepaynspray", "/addpaynspray", "Létrehozol egy festőmühelyt" },
					{ "/nearbypaynsprays", "/nearbypaynsprays", "Mutatja a közeli festőmühelyeket" },
					{ "/delpaynspray", "/delpaynspray [id]", "Törlöd a lerakott festőmühelyt" },
					
					-- phone/*
					{ "/addphone", "/addphone", "Leraksz egy telefonfülkét" },
					{ "/nearbyphones", "/nearbyphones", "Mutatja a közeli telefonfülkéket" },
					{ "/delphone", "/delphone [id]", "Türlöd a lerakott telefonfülkéket" },
					
					-- interiors/*
					{ "/enableallelevators", "/enableallelevators", "Liftek bekapcsolása" },
					
					{ "/addinterior", "/addinterior  [Interior ID] [TYPE] [Cost] [Name]","Létrehozol egy interiort" },
					{ "/delinterior", "/delproperty","Törlöd az interiort" },
					{ "/getinteriorid", "/getinteriorid [id]","Interiorba telézel" },
					{ "/setinteriorid", "/setinteriorid [id]","Interior lecserélése másikra" },
					{ "/getinteriorprice", "/getinteriorprice","Interior árak megmutatása" },
					{ "/setinteriorprice", "/setinteriorprice [price]","Interior belépés árának modositása" },
					{ "/setinteriortype", "/setinteriortype [type]","Interior tipusának lecserélése" },
					{ "/toggleinterior", "/toggleinterior [id]","készletek belső engedélyezett vagy tiltott" },
					{ "/enableallinteriors", "/enableallinteriors","Interiorr bekapcsolása" },
					{ "/setinteriorexit", "/setinteriorexit","Interior be és kilépés megadása" },
					{ "/setinteriorentrance", "/setinteriorentrance  [Interior ID]","megváltoztatja egy belső bejárati helyét" },
					
					-- factions/*
					{ "/setfactionleader", "/setfactionleader [player] [factionid]", "Frakcioleadert adsz neki" },
					{ "/setfactionrank", "/setfactionrank [player] [rank]", "Frakciórangot adsz neki" },
					{ "/makefaction", "/makefaction [type] [name]", "frakcio leadert adsz neki" },
					{ "/renamefaction", "/renamefaction [id] [new name]", "Frakció átnevezése" },
					{ "/setfaction", "/setfaction [id] [factionid]", "Frakcio létrehozás ig" },
					{ "/delfaction", "/delfaction [id]", "Frakcio törlése" },
					
					-- fuelpoints/*
					{ "/addfuelpoint", "/addfuelpoint", "Leraksz egy benzinkutat" },
					{ "/nearbyfuelpoints", "/nearbyfuelpoints", "Mutatja a közeli benzinkutakat" },
					{ "/delfuelpoint", "/delfuelpoint [id]", "Törlöd a lerakott benzinkutakat" },
					
					-- player/*
					{ "/ck", "/ck [player] [cause of death]", "Kinyirod a playert" },
					{ "/unck", "/unck [player]", "visszatér karaktert ölni" },
					
					-- Weapons
					{ "/makegun", "/makegun", "Játékosnak adsz vele fegyvert,Visszaéllsz vele bann" },
					{ "/makeammo", "/makeammo", "Játékosnak adsz vele töltényt,Visszaéllsz vele bann" },
					
					-- Etc
					{ "/setmoney", "/setmoney [player] [money]", "Játékosnak adsz vele pénzt,Visszaéllsz vele bann" },
					{ "/givemoney", "/givemoney [player] [money]", "Játékosnak adsz vele pénzt,Visszaéllsz vele bann" },
					{ "/resetcharacter", "/resetcharacter [Firstname_Lastname]", "teljes mértékben visszaálláitja a karaktert" },
					{ "/setvehlimit", "/setvehlimit [player] [limit]", "Játékos max kocsi limitjét állitod vele" },
					{ "/adminstats", "shows admin stats" },
				},
				-- level 5: Head Admins
				{
					-- player/*
					{ "/givevpoints", "/givevpoints [player] [points] [reason]", "Tisztelet pontot adsz a playernek" },
					{ "/hideadmin", "/hideadmin", "váltás rejtett / látható az admin " },
					{ "/ho", "/ho [text]", "OOC chaten rejted el magad" },
					{ "/hw", "/hw [player] [text]", "Pm elől bujsz el" },
					{ "/makeadmin", "/makeadmin [player] [rank]", "Admint nevezel ki vele" },
					
					-- resource/*
					{ "/startres", "/startres [resource name]", "Mappákat inditod vele" },
					{ "/stopres", "/stopres [resource name]", "Mappákat állitod le vele" },
					{ "/restartres", "/restartres [resource name]", "Mappák ujrainditása" },
					{ "/rcs", "/rcs", "Erőforrás-Keeper " },
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
addCommandHandler("ah", adminhelp)
