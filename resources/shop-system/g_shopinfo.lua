--- clothe shop skins
blackMales = {7, 14, 15, 16, 17, 18, 20,  22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 80,  103,  105, 106, 107, 134, 136, 142, 143, 144, 156, 166, 168, 176, 180, 182, 185, 220,  249, 253, 260}
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72,  78, 81,  94, 95, 96, 97, 98, 99, 100, 101,  111, 112,  114, 116, 120, 121, 122, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155,   164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242,  248, 250, 252,  255, 258, 259, 261, 264, 272 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 245, 256 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263}
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 22, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }

g_shops = {
	{ -- 1
		name = "Vegyesbolt",
		description = "Ez a bolt vegyesárú értékesítésével foglalkozik.",
		image = "general.png",
		
		{
			name = "Vegyesárú",
			{ name = "Virág", description = "Egy szép csokor virág.", price = 2000, itemID = 115, itemValue = 14 },
--			{ name = "Phonebook", description = "A large phonebook of everyones phone numbers.", price = 30, itemID = 7 },
			{ name = "Dobókocka", description = "Egy fehér dobókocka, fekete pontokkal. Szerencsejátékra.", price = 150, itemID = 10 },
			{ name = "Golf ütő", description = "Egy kitűnő minőségű golfütő.", price = 12000, itemID = 115, itemValue = 2 },
			{ name = "Baseball Bat", description = "Jó játékot!", price = 60, itemID = 115, itemValue = 5 },
			{ name = "Ásó", description = "'for farmers' felirat olvasható a nyelén.", price = 5000, itemID = 115, itemValue = 6 },
			{ name = "Biliárd dákó", description = "Biliárd játékhoz.", price = 5400, itemID = 115, itemValue = 7 },
			{ name = "Járóbot", description = "Egy bot ami soha nem volt ízléses..", price = 1350, itemID = 115, itemValue = 15 },
			{ name = "Poroltó", description = "Sose tudhatod, mikor lesz baj.", price = 4200, itemID = 115, itemValue = 42 },
			{ name = "Festékszóró", description = "De azért ne vandálkodjunk!", price = 15000, itemID = 115, itemValue = 41 },
			{ name = "Ejtőernyő", description = "Ha nem szeretnél a földre loccsanni.", price = 500000, itemID = 115, itemValue = 46 },
			{ name = "Város ismertető", description = "Ha nem szeretnél eltévedni.", price = 1000, itemID = 18 },
			{ name = "Hátizsák", description = "Egy ésszerű méretű hátizsák.", price = 5000, itemID = 48 },
			{ name = "Horgászbot", description = "7 lábnyi méretű szénacél horgászbot.", price = 12000, itemID = 49 },
			{ name = "Símaszk", description = "Egy fekete símaszk.", price = 4000, itemID = 56 },
			{ name = "Benzinkanna", description = "Egy piros, fém benzineskanna.", price = 3500, itemID = 57, itemValue = 0 },
			{ name = "Elsősegély csomag", description = "Életet ment.. Jó ha van nálad.", price = 8000, itemID = 70, itemValue = 3 },
			{ name = "Mini jegyzetfüzet", description = "Egy mini jegyzetfüzet, 5 üres lappal.", price = 500, itemID = 71, itemValue = 5 },
			{ name = "Jegyzetfüzet", description = "Egy jegyzetfüzet, 50 üres lappal.", price = 1000, itemID = 71, itemValue = 50 },
			{ name = "XXL jegyzetfüzet", description = "Egy óriási jegyzetfüzet, 125 üres lappal.", price = 2000, itemID = 71, itemValue = 125 },
			{ name = "Sisak", description = "Biciklizéshez ideális.", price = 5000, itemID = 90 },

			{ name = "Cigaretta", description = "Jó minőségű cigaretta.", price = 1000, itemID = 105, itemValue = 20 },
			{ name = "Öngyújtó", description = "Tűz csinálásához.", price = 150, itemID = 107 },
			{ name = "Kés", description = "Hogy segíts a konyhában.", price = 5000, itemID = 115, itemValue = 4 },
			{ name = "Kártyapakli", description = "Egy kártyapakli játékhoz.", price = 1000, itemID = 77 },
		},
		{
			name = "Élelmiszer",
			{ name = "Szendvics", description = "Fincsi csomagolt szenya, sajttal.", price = 450, itemID = 8 },
			{ name = "Üdítő", description = "Egy dobozos üditő.", price = 300, itemID = 9 },
		}
	},
	{ -- 2
		name = "Fegyverbolt",
		description = "Minden fegyver ami neked kell, 1914 óta.",
		image = "gun.png",
		
		{
			name = "Fegyver és töltény",
			{ name = "9mm kézifegyver", description = "Egy ezüstből készült pisztoly.", price = 50000, itemID = 115, itemValue = 22, license = true },
			{ name = "9mm tölténycsomag", description = "Tölténycsomag, benne 17 golyó, kompatibilis Colt-45el.", price = 20000, itemID = 116, itemValue = 22, ammo = 17, license = true },
			--{ name = "Shotgun", description = "A silver shotgun.", price = 110000, itemID = 115, itemValue = 25, license = true },
			--{ name = "10 Beanbag Rounds", description = "10 rounds for a discount price!.", price = 20000, itemID = 116, itemValue = 25, ammo = 10, license = true },
			{ name = "Country Rifle", description = "A country rifle", price = 90000, itemID = 115, itemValue = 33, license = true },
			{ name = "Country Rifle magazine", description = "Magazine with 10 rounds for an country rifle", price = 30000, itemID = 116, itemValue = 33, ammo = 10, license = true },
			{ name = "Ajtó feltörő", description = "Bank ajtó feltörő", price = 40000, itemID = 122, itemValue = 25, license = true },
		}
	},
	{ -- 3
		name = "Étterem",
		description = "A föld legfinomabb ételei és innivalói.",
		image = "food.png",
		
		{
			name = "Étel",
			{ name = "Szendvics", description = "Egy finom sajtos szendvics.", price = 450, itemID = 8 },
			{ name = "Taco", description = "Egy zsíros mexikói taco.", price = 1200, itemID = 11 },
			{ name = "Burger", description = "Egy duplasajtos burger baconnel.", price = 1000, itemID = 12 },
			{ name = "Fánk", description = "Egy forró, ragadós, cukorral szórt fánk.", price = 200, itemID = 13 },
			{ name = "Süti", description = "Egy finom csokis süti.", price = 150, itemID = 14 },
			{ name = "Hotdog", description = "Egy forró, finom hotdog.", price = 500, itemID = 1 },
			{ name = "Palacsinta", description = "Hmm, egy palacsinta.. Fincsii!", price = 200, itemID = 108 },
		},
		{
			name = "Innivaló",
			{ name = "Üdítő", description = "Egy dobozos üditő.", price = 500, itemID = 9 },
			{ name = "Víz", description = "Egy üveg ásványvíz.", price = 250, itemID = 15 },
		}
	},
	{ -- 4
		name = "Falusi vegyes",
		description = "Alapvető élelmiszerbolt.",
		image = "general.png",
		
		{
			name = "Falusi vegyes",
			{ name = "Virág", description = "Egy szép csokor virág.", price = 2000, itemID = 115, itemValue = 14 },
			{ name = "Festékszóró", description = "De azért ne vandálkodjunk!", price = 15000, itemID = 115, itemValue = 41 },
			{ name = "Hátizsák", description = "Egy ésszerű méretű hátizsák.", price = 5000, itemID = 48 },
			{ name = "Símaszk", description = "Egy fekete símaszk.", price = 4000, itemID = 56 },
			{ name = "Elsősegély csomag", description = "Életet ment.. Jó ha van nálad.", price = 8000, itemID = 70, itemValue = 3 },
			{ name = "Mini jegyzetfüzet", description = "Egy mini jegyzetfüzet, 5 üres lappal.", price = 700, itemID = 71, itemValue = 5 },
			{ name = "Cigaretta", description = "Jó minőségű cigaretta.", price = 2000, itemID = 105, itemValue = 20 },
			{ name = "Öngyújtó", description = "Tűz csinálásához.", price = 150, itemID = 107 },
			{ name = "Kártyapakli", description = "Egy kártyapakli játékhoz.", price = 1000, itemID = 77 },
		},
	},
	{ -- 5
		name = "Ruhabolt",
		description = "Ezekben a ruhákban nézel ki, igazán jól!",
		image = "clothes.png",
		-- Items to be generated elsewhere.
		{
			name = "Rád illő ruhák"
		},
		{
			name = "Egyebek"
		}
	},
	{ -- 6
		name = "Gym",
		description = "A legjobb hely, harcstílusok tanulásához.",
		image = "general.png",
		
		{
			name = "Oktató könyvek",
			{ name = "Egyszerű Harcmozdulatok Kezdőknek", description = "Ezzel a könyvvel egyszerű ((alap)) harcmozdulatokat tanulhatsz.", price = 500, itemID = 20 },
			{ name = "Box Mozdulatok Kezdőknek", description = "Ezzel a könyvvel Box mozdulatokat tanulhatsz.", price = 500, itemID = 21 },
			{ name = "Kung Fu Mozdulatok Kezdőknek", description = "Ezzel a könyvvel Kung Fu mozdulatokat tanulhatsz.", price = 500, itemID = 22 },
			-- item ID 23 is just a greek book, anyhow :o
			{ name = "Grabkick Mozdulatok Kezdőknek", description = "Ezzel a könyvvel Grabkick mozdulatokat tanulhatsz.", price = 500, itemID = 24 },
			{ name = "Elbow Mozdulatok Kezdőknek", description = "Ezzel a könyvvel Elbow mozdulatokat tanulhatsz.", price = 500, itemID = 25 },
		}
	},
	{ -- 7
		name = "Butorbolt.",
		description = "Kika Lakbrendezés.",
		image = "general.png",
		
		{
			name = "Minőségi butorok",
			{ name = "Fenyő Szekrény", description = "", price = 30000, itemID = 123, itemValue = 20 },
			{ name = "ÉjjeliSzekrény", description = "", price = 17000, itemID = 124, itemValue = 20 },
			{ name = "Könyvespolc", description = "", price = 15000, itemID = 125, itemValue = 20 },
			{ name = "Asztal", description = "", price = 10000, itemID = 126, itemValue = 20 },
			{ name = "Üvegasztal", description = "", price = 20000, itemID = 127, itemValue = 20 },
			{ name = "Kanapé", description = "", price = 50000, itemID = 128, itemValue = 20 },
			{ name = "BőrKanapé", description = "", price = 90000, itemID = 129, itemValue = 20 },
			{ name = "Fotel", description = "", price = 70000, itemID = 130, itemValue = 20 },
			{ name = "Franciaágy", description = "", price = 60000, itemID = 131, itemValue = 20 },
			{ name = "ágy", description = "", price = 30000, itemID = 132, itemValue = 20 },
			{ name = "Tigris mintás Szőnyeg", description = "", price = 18000, itemID = 133, itemValue = 20 },
			{ name = "Mosógép", description = "", price = 60000, itemID = 134, itemValue = 20 },
			{ name = "Wc", description = "", price = 10000, itemID = 135, itemValue = 20 },
			{ name = "Mósdó", description = "", price = 13000, itemID = 136, itemValue = 20 },
			{ name = "Fürdőkád", description = "", price = 40000, itemID = 137, itemValue = 20 },
			{ name = "Zuhanyzó", description = "", price = 45000, itemID = 138, itemValue = 20 },
			{ name = "Konyhabutor", description = "", price = 65000, itemID = 139, itemValue = 20 },
			{ name = "Hütő", description = "", price = 32000, itemID = 140, itemValue = 20 },
			{ name = "Állólámpa", description = "", price = 11000, itemID = 141, itemValue = 20 },
			{ name = "Televizio", description = "", price = 50000, itemID = 142, itemValue = 20 },
			{ name = "Étkezőasztal", description = "", price = 39000, itemID = 143, itemValue = 20 },
			{ name = "Hangfalak", description = "", price = 10000, itemID = 144, itemValue = 20 },
			{ name = "Szobanövények", description = "", price = 8000, itemID = 145, itemValue = 20 },
			{ name = "Szobanövények", description = "", price = 8000, itemID = 146, itemValue = 20 },
			{ name = "Szobanövények", description = "", price = 8000, itemID = 147, itemValue = 20 },
		}
	},
	{ -- 8
		name = "Elektronikai Szaküzlet",
		description = "A legújabb technológiák, kedvedre.",
		image = "general.png",
		
		{
			name = "Szórakoztató elektronika",
			{ name = "Ghettoblaster", description = "Egy fekete Ghettoblaster márkájú magnó.", price = 3500, itemID = 54 },
			{ name = "Kamera", description = "Analóg kamera.", price = 15000, itemID = 115, itemValue = 43 },
			{ name = "Mobiltelefon", description = "Egy stílusos, fekete okostelefon.", price = 15000, itemID = 2 },
			{ name = "Rádió", description = "Maradj kapcsolatban!", price = 1500, itemID = 6 },
			{ name = "Fülhallgató", description = "Egy fülhallgató rádióhoz.", price = 500, itemID = 88 },
			{ name = "Óra", description = "Ne késs el!", price = 500, itemID = 17 },
			{ name = "MP3 lejátszó", description = "Egy kicsi, sima tapintású MP3 lejátszó.", price = 1200, itemID = 19 },
			--{ name = "Kémikus szett", description = "Egy kicsi kémia szett.", price = 20000, itemID = 44 },
			{ name = "Széf", description = "Egy széf amiben az értékeidet biztonságban tudhatod.", price = 300000, itemID = 60 },
			{ name = "GPS", description = "Egy GPS az autódba.", price = 10000, itemID = 67 },
			{ name = "PDA", description = "Egy PDA, kiváló e-mailek olvasására és internetezésre.", price = 15000, itemID = 96 },
			{ name = "Hordozható TV", description = "Egy hordozható TV, TV adások nézésére.", price = 7500, itemID = 104 },
			{ name = "Úthasználati díjfizető", description = "Egy autóba rakható, automatikus úthasználati díjfizető készülék.", price = 4000, itemID = 118 },
		}
	},
	{ -- 9
		name = "Alkohol üzlet",
		description = "A vodkától kezdve a sörig, minden van itten'.",
		image = "general.png",
		
		{
			name = "Alkohol",
			{ name = "Soproni ászok", description = "Egy minőségi sör.", price = 200, itemID = 58 },
			{ name = "Bastradov Vodka", description = "A legjobb barátaidnak - Bastradov Vodka.", price = 1200, itemID = 62 },
			{ name = "Scottish Whiskey", description = "Egy kitűnő whiskey, egyenesen Skóciából.", price = 5000, itemID = 63 },
			{ name = "Üdítő", description = "Egy dobozos üditő.", price = 250, itemID = 9 },
		}
	},
	{ -- 10
		name = "Könyvesbolt",
		description = "Új dolgokat akarsz tanulni? Akkor itt a helyed!",
		image = "general.png",
		
		{
			name = "Könyvek",
			{ name = "Város ismertető", description = "Egy kis városismertető füzet.", price = 1000, itemID = 18 },
			{ name = "Los Santos Közlekedési Kézikönyv", description = "Egy füzet közlekedésrendészeti szabályokkal.", price = 1000, itemID = 50 },
			{ name = "Kémia 101", description = "Bevezetés a kémiába.", price = 2000, itemID = 51 },
		}
	},
	{ -- 11
		name = "Kávézó",
		description = "Ha szeretnél egy finom forró italt itt a helyed!",
		image = "food.png",
		
		{
			name = "Érel",
			{ name = "Fánk", description = "Egy meleg cukrozott pudingal töltött finomság", price = 250, itemID = 13 },
			{ name = "Cookie", description = "Csokis süti a javábol ínyenceknek", price = 300, itemID = 14 },
		},
		{
			name = "Italok",
			{ name = "Coffee", description = "Egy fekete Tchibo kávé.", price = 150, itemID = 83, itemValue = 2 },
			{ name = "Üdítő", description = "Egy dobozos üditő.", price = 250, itemID = 9, itemValue = 3 },
			{ name = "Víz", description = "Egy üveg ásványvíz", price = 200, itemID = 15, itemValue = 2 },
		}	
	},
	{ -- 12
		name = "Paintball ",
		description = "Titkos",
		image = "general.png",
		
		{
			
			name  = "Kiszolgáló személy",
			{ name = "m4", description = "m4.", price = 80000, itemID = 115, itemValue = 31, license = true },
			{ name = "m4 tölténycsomag", description = "m4 1000 golyo.", price = 40000, itemID = 116, itemValue = 31, ammo = 200, license = true },
			{ name = "ak47", description = "ak47.", price = 80000, itemID = 115, itemValue = 30, license = true },
			{ name = "ak47 tölténycsomag", description = "ak47 1000 golyo.", price = 40000, itemID = 116, itemValue = 30, ammo = 200, license = true },
			{ name = "tec9", description = "tec9.", price = 60000, itemID = 115, itemValue = 32, license = true },
			{ name = "tec9 tölténycsomag", description = "tec9 1000 golyo.", price = 30000, itemID = 116, itemValue = 32, ammo = 200, license = true },
			{ name = "mp5", description = "mp5.", price = 60000, itemID = 115, itemValue = 29, license = true },
			{ name = "mp5 tölténycsomag", description = "mp5 1000 golyo.", price = 30000, itemID = 116, itemValue = 29, ammo = 200, license = true },
			{ name = "slienced tölténycsomag", description = "silenced 200 golyo.", price = 5000, itemID = 116, itemValue = 23, ammo = 100, license = true },
			{ name = "silenced", description = "silenced.", price = 10000, itemID = 115, itemValue = 23, license = true }
		}
	
	},
	
	{ -- 13
		name = "Drogos",
		description = "Elárulsz megöllek.",
		image = "general.png",
		
		{
			name  = "Disgusting Stuff",
			{ name = "Kémikus Szett", description = "Lets play the guessing game.", price = 100000, itemID = 44 },
			{ name = "Cannabis Satvia", description = "Drog készitéshez", price = 3000, itemID = 30 },
			{ name = "Lysergic Acid", description = "Drog készitéshez", price = 6000, itemID = 32 },
			{ name = "Cocaine Alkaloid", description = "Drog készitéshez", price = 4500, itemID = 31 },
			{ name = "Feldolgozatlan pcp", description = "Drog készitéshez", price = 6000, itemID = 33 },
			
		}
	},
	{ -- 14
		name = "Autósbolt",
		description = "Kisebb nagyobb alkatrészek!",
		image = "general.png",
		
		-- items to be filled in later
		{
			name = "Autóalkatrész"
		}
	},
	{ -- 15
		name = "Prison Worker",
		description = "Now that looks... vaguely tasty.",
		image = "general.png",
		
		{
			name  = "Börtönőr",
			
			{ name = "m4", description = "m4.", price = 0, itemID = 115, itemValue = 31, license = true },
			{ name = "m4 tölténycsomag", description = "m4 100 golyo.", price = 0, itemID = 116, itemValue = 31, ammo = 200, license = true },
			{ name = "deagle", description = "deagle.", price = 0, itemID = 115, itemValue = 24, license = true },
			{ name = "deagle tölténycsomag", description = "deagle 100 golyo.", price = 0, itemID = 116, itemValue = 24, ammo = 100, license = true },
			{ name = "sniper", description = "sniper.", price = 0, itemID = 115, itemValue = 34, license = true },
			{ name = "sniper tölténycsomag", description = "sniper 100 golyo.", price = 0, itemID = 116, itemValue = 34, ammo = 100, license = true },
			{ name = "mp5", description = "mp5.", price = 0, itemID = 115, itemValue = 29, license = true },
			{ name = "mp5 tölténycsomag", description = "mp5 200 golyo.", price = 0, itemID = 116, itemValue = 29, ammo = 200, license = true },
			{ name = "ak47 tölténycsomag", description = "ak47 200 golyo.", price = 0, itemID = 116, itemValue = 30, ammo = 200, license = true },
			{ name = "ak47", description = "ak47.", price = 0, itemID = 115, itemValue = 30, license = true }
		}
	},
	
	
	
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['language-system']:getLanguageCount() do
		local ln = exports['language-system']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " szótár", description = "Egy szótár " .. ln .. " tanulásához.", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getItemFromIndex( shop_type, index )
	local shop = g_shops[ shop_type ]
	if shop then
		for _, category in ipairs( shop ) do
			if index <= #category then
				return category[index]
			else
				index = index - #category
			end
		end
	end
end

--
local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- one simple small cache it is - prevents us from creating those tables again and again
		--[[
		local c = simplesmallcache[tostring(race) .. "|" .. tostring(gender)]
		if c then
			shop = c
			return
		end
		]]
		
		-- load the shop
		local shop = g_shops[shop_type]
		
		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			table.insert( shop[1], { name = "Ruha " .. v, description = "Ruha #" .. v .. ".", price = 30000, itemID = 16, itemValue = v, fitting = true } )
			nat[v] = true
		end
		
		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)
		
		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Ruha " .. v, description = "Ruha #" .. v .." - ezt nem tudod hordani.", price = 30000, itemID = 16, itemValue = v } )
		end
		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		local c = simplesmallcache["vm"]
		if c then
			return
		end
		
		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end
		
		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['item-system']:getItemDescription( 114, v )
				
				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
			end
		end
		
		simplesmallcache["vm"] = true
	end
end
