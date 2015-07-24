local myadminWindow = nil

function adminhelp (commandName)

	local sourcePlayer = getLocalPlayer()
	if exports.global:isPlayerAdmin(sourcePlayer) then
		if (myadminWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myadminWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Kocsi modellek", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myadminWindow)
			local lists = {}
			for level = 1, 5 do 
				local tab = guiCreateTab("Kocsik " .. level, tabPanel)
				lists[level] = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab) -- commands for level one admins 
				guiGridListAddColumn (lists[level], "Modell id", 0.15)
				guiGridListAddColumn (lists[level], "Alap modell neve", 0.35)
				guiGridListAddColumn (lists[level], "Modolt modell neve", 1.3)
			end
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Bezár", true, myadminWindow) -- close button
			
			local commands =
			{
				-- level 1: Trial Admin
				{
					-- player/*
					{ "400", "Landstalker", "Mercedes Terepjáró" },
					{ "401", "Bravura", "VW Passat"},
					{ "402", "Buffalo", "Nyugi a nappaliban" },
					{ "403", "Linerunner", "Nincs Modolva" },
					{ "404", "Perenniel", "Bmw 540i" },
					{ "405", "Sentinel", "Nincs Modolva" },
					{ "406", "Dumper", "Nincs Modolva" },
					{ "407", "Firetruck", "Nincs Modolva" },
					{ "408", "Trashmaster", "Kukáskocsi" },
					{ "409", "Stretch", "Limuzin" },
					{ "410", "Manana", "Trabant" },
					{ "411", "Infernus", "Lamborghini" },
					{ "412", "Voodoo", "Nincs Modolva" },
					{ "413", "Pony", "Nincs Modolva" },
					{ "414", "Mule", "Nincs Modolva" },
					{ "415", "Cheetah", "Nincs Modolva" },
					{ "416", "Ambulance", "Mentő" },
					{ "417", "Leviathan", "Nincs Modolva" },
					{ "418", "Moonbeam", "Nincs Modolva" },
					{ "419", "Esperanto", "Nincs Modolva" },
					{ "420", "Taxi", "Mazda Taxi" },
					{ "421", "Washington", "Nincs Modolva" },
					{ "422", "Bobcat", "Nincs Modolva" },
					{ "423", "Mr Whoopee", "Nincs Modolva" },
					
				},
				{
					-- player/*
					{ "424", "BF Injection", "Nincs Modolva" },
					{ "425", "Hunter", "Nincs Modolva" },
					{ "426", "Premier", "Nincs Modolva" },
					{ "427", "Enforcer", "Rendör modolt busz" },
					{ "428", "Securicar", "Nincs Modolva" },
					{ "429", "Banshee", "Ferrari cabrio" },
					{ "430", "Predator", "Nincs Modolva" },
					{ "431", "Bus", "Volánbusz" },
					{ "432", "Rhino", "Nincs Modolva" },
					{ "433", "Barracks", "Kamaz" },
					{ "434", "Hotknife", "Nincs Modolva" },
					{ "435", "Article Trailer", "Nincs Modolva" },
					{ "436", "Previon", "Nincs Modolva" },
					{ "437", "Coach", "Nincs Modolva" },
					{ "438", "Cabbie", "Nincs Modolva" },
					{ "439", "Stallion", "Nincs Modolva" },
					{ "440", "Rumpo", "Nincs Modolva" },
					{ "441", "RC Bandit", "Nincs Modolva" },
					{ "442", "Romero", "Nincs Modolva" },
					{ "443", "Packer", "Nincs Modolva" },
					{ "444", "Monster", "Nincs Modolva" },
					{ "445", "Admiral", "audi a8" },
					{ "446", "Squallo", "Nincs Modolva" },
					{ "447", "Seasparrow", "Nincs Modolva" },
					},
					{
					-- player/*
					{ "448", "Pizzaboy", "Nincs Modolva" },
					{ "449", "Tram", "Nincs Modolva" },
					{ "450", " Article Trailer 2", "Nincs Modolva" },
					{ "451", "Turismo", "Nincs Modolva" },
					{ "452", "Speeder", "Nincs Modolva" },
					{ "453", "Reefer", "Nincs Modolva" },
					{ "454", "Tropic", "Nincs Modolva" },
					{ "455", "Flatbed", "Nincs Modolva" },
					{ "456", "Yankee", "Nincs Modolva" },
					{ "457", "Caddy", "Nincs Modolva" },
					{ "458", "Solair", "Nincs Modolva" },
					{ "459", "Industrial", "Nincs Modolva" },
					{ "460", "Skimmer", "Nincs Modolva" },
					{ "461", "PCJ-600", "Nincs Modolva" },
					{ "462", "Faggio", "Robogó" },
					{ "463", "Freeway", "harley" },
					{ "464", "RC Baron", "Nincs Modolva" },
					{ "465", " RC Raider", "Nincs Modolva" },
					{ "466", "Glendale", "Nincs Modolva" },
					{ "467", "Oceanic", "Nincs Modolva" },
					{ "468", "Sanchez", "Krosszmotor" },
					{ "469", "Sparrow", "Nincs Modolva" },
					{ "470", "Patriot", "Nincs Modolva" },
					{ "471", "Quad", "Nincs Modolva" },
					{ "472", "Coastguard", "Nincs Modolva" },
					},
				{
					-- player/*
					{ "473", "Dinghy", "Nincs Modolva" },
                    { "474", "Hermes", "Nincs Modolva" },
					{ "475", "Sabre", "Rally" },
					{ "476", "Rustler", "Nincs Modolva" },
					{ "477", "ZR-350", "Dodge" },
					{ "478", "Walton", "Nincs Modolva" },
					{ "479", "Regina", "Lada" },
					{ "480", "Comet", "Porshe" },
					{ "481", " BMX", "Nincs Modolva" },
					{ "482", "Burrito", "modolt" },
					{ "483", "Camper", "Barkas" },
					{ "484", "Marquis", "Nincs Modolva" },
					{ "485", "Baggage", "Nincs Modolva" },
					{ "486", "Dozer", "Nincs Modolva" },
					{ "487", "Maverick", "Nincs Modolva" },
					{ "488", "SAN News Maverick", "Nincs Modolva" },
					{ "489", "Rancher", "Nincs Modolva" },
					{ "490", "FBI Rancher", "Rabszállitó" },
					{ "491", "Virgo", "Bentley" },
					{ "492", "Greenwood", "Bmw 780i" },
					{ "493", "Jetmax", "Nincs Modolva" },
					{ "494", "Hotring Racer", "Ferrari" },
					
					},
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
addCommandHandler("modell", adminhelp)
