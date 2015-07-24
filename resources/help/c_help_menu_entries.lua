help_menu =
{
	name = "Help",
	camera = { { matrix = { 1480, -1620, 13.8, 1480, -1623, 14.5 }, interior = 0, dimension = 20 } },
	
	-- when a window is going to be created, this function is called to fill it
	window = {
		text = "Üdvözöllek a Segédletben\n\nCsak válassz egy témát ami érdekel.\n\nHa nem adott kielégítő választ számodra, akkor megkereshetsz egy online Admint /report(F2)-vel."
	},
	{
		name = "Kezdetek",
		multi = true,
		{
			name = "Érkezés",
			camera = {
				{ matrix = { 1733 ,-1854, 16, 1802, -1920, -11, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1707, -2183, 15, 1638, -2254, 10, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "Ha megérkezel a városba akkor először is munkát kereshetsz. E legjobb ha a városházára mész ilyen ügyben.\nLegális munka a legjobb ha nem szeretnél bajba kerülni, ha mégsem ezt az utat választod nézd meg a munkák szekciót."
			}
		},
		
		{
			name = "Indulj el az utadon",
			camera = {
				{ matrix = { 1948, -1745, 16, 1914, -1838, -0, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 1777, -1368, 41, 1747, -1301, -25, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "Mostantól pénzt tudsz keresni a munkáddal, de szeretnél azért találni néhány új barátot? Ha esetleg a v álaszod igen, akkor mindenképpen látogass el az Idlewood-i benzinkúthoz, itt nagyon sok emberrel találkozhatsz.\nVagy egy Club-ba szeretnél elmenni? Ez is elő van készítve neked.\nEz a te életed úgy éled ahogyan te akarod!"
			},
		}
	},
	{
		name = "Frakciók",
		window = {
			bottom = true,
			text = "Ha szeretnéd a játékot egy sokkal magasabb szintre emelni ahhoz egy frakcióhoz kell csatlakoznod, ehhez el kell olvasnod a fórumon a Role Play leírások szekciót, enélkül nem is fognak sehova felvenni:\n\nwww.see-rpg.com\n\nNéhány állami frakció megköveteli az írásos jelentkezést is."
		},
	},
	{
		name = "Munkák",
		camera = {
			{ matrix = { 383, 174, 1009.7, 380, 174, 1009.6 }, interior = 3, dimension = 125 },
			{ matrix = { 1485, -1620, 72, 1485, -1720, 72 },   interior = 0, dimension = 0 },
			{ matrix = { 1483, -1710, 13.4, 1483, -1805, 44 }, interior = 0, dimension = 0 }
		},
		window = {
			text = "Az összes legális munkát a Városházán tudod felvenni.\n\nCsak be kell sétálnod és szembe a kör asztalnál lévő kívánatos hölggyel kell társalognod.\n\nHa illegális munkát szeretnél találnod kell egy embert aki ilyeneket ajánl."
		},
		{
			name = "Csomagszállítás",
			multi = true,
			-- page one: depot (start)
			{
				name = "Csomagszállítás",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 0 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nHa felvetted ezt a munkát akkor el kell menned Nyugat Los Santos külső peremére ott fel tudod venni a furgonod.\n\nHa nincsen ott Furgon akkor várnod kell míg visszajön egy."
				}
			},
			
			-- page two: checkpoints
			{
				name = "Csomagszállítás II",
				camera = {
					{ matrix = { 1811, -1830, 22, 1886, -1873, -28 }, interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "Akkor amikor beültél a furgonba meg fogy jelenni egy jelzés a radaron mely a célpontot jelzi, ez az a hely ahova a csomagokat le kell adnod.\n\nItt csak be kell állnod a jelzésbe és várnod egy kicsit majd a következő jelzéshez menni.\n\nA fizetésedet a jármű sérülése alapján kapod."
				},
				onInit =
					function( )
						marker = createMarker( 1826.69140625, -1845.1533203125, 13.578125, "checkpoint", 4, 255, 200, 0, 150 )
						setElementDimension( marker, 20 )
						
						vehicle = createVehicle( 414,  1826, -1845, 13.6, 0, 0, 30 )
						setElementDimension( vehicle, 20 )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
						
						destroyElement( vehicle )
						vehicle = nil
					end
			},
			
			-- page three: depot
			{
				name = "Csomagszállítás III",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 20 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "\nAmikor úgy gondolod hogy elég pénz gyűjtöttél össze akkor indulj vissza a piros jelzéshez."
				},
				onInit =
					function( )
						marker = createMarker(-69.087890625, -1111.1103515625, 0.64266717433929, "checkpoint", 4, 255, 0, 0, 150)
						setElementDimension( marker, 20 )
						setMarkerIcon( marker, "finish" )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
					end
			}
		},
		{
			name = "Taxi Sofőr",
			multi = true,
			-- page one: Getting the Job
			{
				name = "Taxi Sofőr I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nAhhoz hogy taxi sofőr legyél el kell menned a városházára.\nHa bemész az épületbe, akkor csak menj az asztalnál ülő hölgyhöz.\nVálaszd a taxisofőr opciót és fogadd el.\nHa ezeket megtetted, akkor megtetted az első lépést hogy Taxi Sofőr legyél!"
				}
			},
			
			-- page two: starting the job
			{
				name = "Taxi Sofőr II",
				camera = {
					{ matrix = { 1819, -1815, 29, 1754, -1887, 6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1756, -1950, 32, 1803, -1869, 5, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nItt tudod felvenni a Taxidat.\nEz a központi állomás, a Taxik a mögötte lévő parkolóban parkolnak.\nHa idáig is eljutottál jöhet a következő lépés!"
				},
			},
			
			-- page three: On Duty
			{
				name = "Taxi Sofőr III",
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nMár úton is vagy hogy pénzt keress Taxi sofőrként! Innentől kezdve a dolgok nagyon egyszerűek.\nMostantól csak vezess és várj a hívásokra vagy valakire akinek segítsége van rád.\nHa hívás érkezik indulj a pozícióra!"
				},
			} 
		},
		{
			name = "Busz Sofőr",
			multi = true,
			-- page one: Getting the job
			{
				name = "Busz sofőr I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nAhhoz hogy busz sofőr legyél el kell menned a városházára.\nHa bemész az épületbe, akkor csak menj az asztalnál ülő hölgyhöz.\nVálaszd a Buszsofőr opciót és fogadd el.\nHa ezeket megtetted, akkor megtetted az első lépést hogy busz sofőr legyél!"
				}
			},
			
			-- page two: Starting the job
			{
				name = "Busz sofőr II",
				camera = {
					{ matrix = { 1819, -1815, 29, 1754, -1887, 6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1756, -1950, 32, 1803, -1869, 5, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nMár úton is vagy hogy pénzt keress busz sofőrként! Innentől kezdve a dolgok nagyon egyszerűek.\nHa ez a lépés is megvan akkor készen állsz arra hogy elkezdj dolgozni!"
				},
			},
			
			-- page three: On Duty
			{
				name = "Busz sofőr III", 
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "Írd be hogy /startbus, és látni fogsz sok-sok jelzést a térképen. Piros és Sárgákat. A feladatod az hogy menj keresztül a sárgákon és állj meg a pirosaknál.\n\nPiros = Stop | Sárga = Útvonal\n\nCsak csináld ezt és megkapod a pénzedet."
				},
			},
		},
		{
			name = "Közterület felügyelő",
			multi = true,
			-- page one: getting the job
			{
				name = "Közterület felügyelő I",
				camera = {
					{ matrix = { 1451, -1723, 46, 1515, -1779, -6, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1512, -1730, 16, 1436, -1795, 14, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 1470, -1760, 22, 1535, -1833, 0, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nAhhoz hogy közterület felügyelő legyél el kell menned a városházára.\nHa bemész az épületbe, akkor csak menj az asztalnál ülő hölgyhöz.\nVálaszd a közterület felügyelő opciót és fogadd el.\nHa ezeket megtetted, akkor megtetted az első lépést hogy közterület felügyelő legyél!"
				},
			},
			
			-- page two: how to do the job
			{
				name = "Közterület felügyelő II",
				camera = {
					{ matrix = { 1810, -1750, 45, 1833, -1664, -0, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2058, -1147, 76, 1982, -1190, 28, 0, 70 }, interior = 0, dimension = 0 },
					{ matrix = { 2044, -1442, 48, 1956, -1468, 10, 0, 70 }, interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nA feladatod az hogy járj körbe a városban és tisztítsd le a felrajzolt graffitiket.\nHa találsz egyet csak fújd át a spray-el.\nMinden Graffity után kapsz adott mennyiségű pénzt."
				},
			}
		},
		{
			name = "Szerelő",
			window = {
				bottom = true,
				text = "\nSzerelőként meg tudod szerelni az emberek járműveit ha ők azt szeretnék.\nValamennyi pénznek kell nálad lenni (Különböző fejlesztés/szerelési költség), jobb klikkelsz a kocsira és kiválasztod a 'Javítás/Szerelés' opciót."
			}
		},
		{
			name = "Lakatos",
			window = {
				bottom = true,
				text = "\nA Lakatosnak semmi elképesztően fontos feladata nincsen. Ez nem az a munka amire nagyon sok embernek szüksége van, de mégis nagyon hasznos.\nA feladatod Jármű/Biznisz/Ház kulcsokat másolni amennyiben megvan az eredeti."
			}
		},
		{
			name = "Illegális munkák",
			camera = {
				{ matrix = { 1425, -1334, 23, 1402, -1241, -2, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nAz illegális munka akármi lehet ami illegális és szeretnéd le RP-zni. Konkrétan nincsen illegális munka.\n\nEnnek a műfajnak csak a képzeleted szab határt!"
			}
		}
	},
	{
		name = "Járművek",
		multi = true,
		-- page one: Grotti Dealership (Cars)
		{
			name = "Grotti Kereskedés",
			camera = {
				{ matrix = { 556, -1263, 34, 526, -1342, -19, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 507, -1280, 34, 591, -1296, -16, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nEzen a helyen tudsz kocsit vásárolni magadnak ha van elég pénzed illetve engedélyed.\nSok féle járművet tudsz ebben a kereskedésben vásárolni.\nFIGYELEM: Ne feledd /park paranccsal leparkolnia a kocsidat hogy ne törlődjön."
			}
		},
		
		-- page two: The Rusted Anchor (Boats)
		{
			name = "A rozsdás Anchor hajókereskedés",
			camera = {
				{ matrix = { 736, -1727, 14, 676, -1657, -24, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 697, -1681, 18, 758, -1743, -29, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 170, -1765, 28, 104, -1836, 3, 0, 70 }, interior = 0, dimension = 0 },
				{ matrix = { 37, -1835, 24, 130, -1816, -6, 0, 70 }, interior = 0, dimension = 0 }
			},
			window = {
				bottom = true,
				text = "\nEz az a hely ahol tudsz magadnak hajót vásárolni ha van egy kis extra pénzed. Azonban ehhez is engedély kell. Öt különböző hajót tudsz itt vásárolni, bár jó drágán. A dokk a Santa Maria parton van.\nFIGYELEM: Ne feledd /park paranccsal leparkolnia a kocsidat hogy ne törlődjön."
			},
		}
	}
}