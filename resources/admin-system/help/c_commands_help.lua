local myCommandsWindow = nil
local sourcePlayer = getLocalPlayer()

function commandsHelp()
	local loggedIn = getElementData(sourcePlayer, "loggedin")
	if (loggedIn == 1) then
		if (myCommandsWindow == nil) then
			guiSetInputEnabled(true)
			local screenx, screeny = guiGetScreenSize()
			myCommandsWindow = guiCreateWindow ((screenx-700)/2, (screeny-500)/2, 700, 500, "Alap Parancsok", false)
			local tabPanel = guiCreateTabPanel (0, 0.1, 1, 1, true, myCommandsWindow)
			local tlBackButton = guiCreateButton(0.8, 0.05, 0.2, 0.07, "Bezár", true, myCommandsWindow) -- close button

			local commands =
			{
				-- FIXME: Order each tab's contents (alphabetically)
				{
					name = "Beszéd",
					{ "'t'", "nyomj 't' [IC szöveg]", "Szerveren Ic be beszélsz", "'t' Hello, az én nevem Jack Hogy vagy?" },
					{ "'y' vagy /r", "/r [IC szöveg]", "Radioba igy tudsz beszélni", "/r Merre vagy koléga? vége" },
					{ "'t'", "nyomj 't' [IC szöveg]", "Szerveren Ic be beszélsz", "'t' Hello, az én nevem Jack Hogy vagy?" },
					{ "'y' vagy /r", "/r [IC szöveg]", "Radioba igy tudsz beszélni", "/r Merre vagy koléga? vége" },
					{ "/tuneradio", "/tuneradio [radio id] [frequency]", "Ezzel tudod a radiot közös frekvenciára állitani" },
					{ "/toggleradio", "/toggleradio [slot]", "Ezzel tudod a radiodat ki/be kapcsolni", "/toggleradio" },
					{ "'b' vagy /b", "/b [OOC szüveg]", "Játékon kivüli chat", "/b Gyere tsre fontos" },
					{ "/me", "/me [IC cselekvés]", "Ezzel tudod lekérni a karakter cselekvését", "/me beverte a fejét" },
					{ "/do", "/do [IC cselekvés]", "Ezzel tudod a karakter cselekvését ismeretlenül kifejezni", "/do Valaki beverte a fejét" },
					{ "/s", "/s [IC szöveg]", "Ezzel tudsz a szerveren kiabálni", "/s Valaki segitsen!!!!!" },
					{ "/f", "/f [OOC szöveg]", "eEzzel tudsz oocbe beszélni frakcion belül", "/f Gyertek tsre buli lessz" },
					{ "/m", "/m [IC szöveg]", "Csak rendöröknek!!ezzel tudsz kihangositva beszélni", "/m állj rendőrség!" },
					{ "/w", "/w [player] [IC szöveg]", "Ezzel tudsz a szerveren suttogni", "/w Jack_Konstantine gyere ide" },
					{ "/d vagy /department", "/d [IC szöveg]", "Rendvédelmi szervezetnek sürgösségi frekvencia" },
					{ "/gov", "/gov [IC szöveg]", "Rendvédelemnek a felhívásai", "/gov Kórház környéke lezárva kérem figyeljenek" },
				},
				{
					name = "Frakció",
					{ "'F3'", "Nyomj 'F3'", "Ezzel tudod megnézni a frakció menüt", "'F3'" },
					{ "/duty", "/duty", "Ezzel tudsz Szolgálatba lépni ha Rendőr vagy", "/duty" },
					{ "Leader", "/fpark", "Ezze tudja a frakció vezető leparkolni a kocsikat", "/fpark"},
					{ "Rendőr", "/backup", "Ezzel tudsz erősitést kérni", "/backup" },
					{ "Rendőr", "/resetbackup [name]", "Ezzel tudod az erősitést lemondani", "/resetbackup" },
					{ "Rendőr", "/ujjlenyomat [player]", "Ezzel tudsz a játékosról ujjlenyomatot venni", "/ujjlenyomat Richard_Banks" },
					{ "Rendőr", "/birsag [player] [összeg] [oka]", "Ezzel tudsz büntetést kiszabni" },
					{ "Rendőr", "/takelicense [player] [license] [hours=0]", "Ezzel tudod a játékos engedélyeit bevonni", "/takelicense Daniela_Lane 1 20" },
					{ "Rendőr", "/arrest [player] [fine] [minutes] [crimes]", "Ezzel tudod börtönbe tenni a bünözöket", "/arrest Daniela_Lane 500 15 gyilkosság" },
					{ "Rendőr", "/release [player]", "Kiadta a játékost letartóztatási idő elött véget ért.", "/release Daniela_Lane" },
					{ "Rendőr", "/jailtime", "Ezzel tudod megnézni ki mennyi börötnt kapott", "/jailtime" },
					{ "Rendőr", "/mdc", "Megnyitja a Mobile Data Computer, ha a járműben ül .", "/mdc" },
					{ "Rendőr", "/rbs", "Ezzel teszel le utzárat", "/rbs" },
					{ "Rendőr", "/delrb [id] vagy /delroadblock [id]", "Ezzel veszed fel az utzárat.", "/delrb 3" },
					{ "Rendőr", "/delallrbs vagy /delallroadblocks", "Ezzel szeded fel az összes utzárat", "/delallrbs" },
					{ "Mentő", "/gyogyit [player]", "Ezzel gyógyitod meg a beteget", "/gyogyit Joe" },
					{ "Mentős", "/vizsgal [player]", "Megmutatja a játékos sérüléseit", "/vizsgal Harry" },
					{ "Mentős", "/assist", "Jeladót helyezel el hogy hol vagy", "/assist"},
					{ "Kormány", "/setbudget [frakcio] [öszeg]", "Ad a kormány a frakcioknak egy kis támogatást", "/setbudget 1 2000000" },
					{ "Kormány", "/settax [százalék]", "Beállitja az általános adókat, például vásárolt tételek.", "/settax 12" },
					{ "Kormány", "/setincometax [százalék]", "Beállitja a jövedelemadót, hogy levonják a bérből minden fizetéskor.", "/setincometax 10" },
					{ "Kormány", "/setwelfare [amount]", "Beállitja az állam a munkanélküliek segélyét", "/setwelfare 150" },
					{ "Kormány", "/gettax", "Mutatja az adót, jövedelemadó és Jóléti.", "/gettax" },
				--{ "Riporter", "/interview [player]", "Felk곩 egy interj򲡮", "/interview Hans_Vanderburg" },
				--{ "Riporter", "/endinterview [player]", "interj򠶩ge", "/endinterview Hans_Vanderburg" },
					--{ "Riporter", "/i [IC Text]", "El񡤡s a hkben ha interj򴠡d valaki.", "/i Yeah, it was pretty hard to come up with that idea." },
					--{ "Ripvagyter", "/tognews", "Hk ki/be kapcsolⴡ", "/tognews" },
					--{ "Ripvagyter", "/news", "ݺenetet k𬤥sz vele", "" },
					--{ "Ripvagyter", "/fvagyecast", "Mutatja az id񪡲Ⳮel񲥪elz괴.", "/fvagyecast" },
					--{ "Ripvagyter", "/pollresults", "Megmutatja a v⭡szt⴩ eredm꯹eket.", "/pollresults" },
					
				},
				{
					name = "Jármű",
					{ "'J'", "Nyomj 'J'", "Ezzel inditod be a kocsit", "'J'" },
					{ "'K'", "Nyomj 'K'", "Ezzel zárod illetve nyitod ki a kocsit", "'K'" },
					{ "'L'", "Nyomj 'L'", "Ezzel kapcsolod ki/be a lámpát", "'L'" },
					{ "'P'", "Nyomj 'P'", "Elakadásjelző", "'P'" },
					{ "'N'", "Nyomj 'N'", "Sürgösségi sziréna", "'N'" },
					{ "/detach", "/detach", "Leválasztja a jármű pótkocsit (ha van ilyen).", "/detach" },
					{ "/park", "/park", "Ezzel tudod leparkolni a kocsit", "/park" },
					{ "/sell", "/sell [player]", "Ezzel tudod eladni a kocsid", "/sell Nathan_Daniels" },
					{ "/handbrake", "/handbrake", "Ezzel huzod be a kéziféket illetve engeded ki", "/handbrake" },
					{ "/eject", "/eject [player]", "Játékos lököd ki a kocsiból", "/eject Nathan_Daniels" },
					{ "/fill", "/fill [amount]", "Ezzel tudod a kocsidat megtankolni", "/fill" },
					{ "/indicatvagy_left", "/indicatvagy_left", "Toggles your left indicatvagys.", "/indicatvagy_left" },
					{ "/indicatvagy_right", "/indicatvagy_right", "Toggles your right indicatvagys.", "/indicatvagy_left" },
					{ "/cc", "/cc", "Ezzel kapcsolod be a tempomatot", "/cc" },
					{ "/ablak", "/ablak", "Ezzel huzod le fel az ablakot a kocsin", "/ablak" },
					{ "/engedelyem", "/engedelyem", "Ezzel mutatod meg az engedélyeid ", "/engedelyem" },
				},
				{
					name = "Tulajdon",
					{ "'F'", "Nyomj 'F'", "Ezzel mész be az interivagyba illetve ki", "'F'" },
					{ "'K'", "Nyomj 'K'", "Ezzel zárod/nyitod a kocsid", "'K'" },
					{ "/unrent", "/unrent", "Ezzel mondod le a bérlést", "/unrent" },
				},
				{
					name = "Items",
					{ "'I'", "Nyomj 'I'", "Ezzel nézed meg zsebed tartalmát", "'I'" },
					{ "'F5'", "Nyomj 'F5'", "Ezzel hivod elő a gps-ed", "'F5'" },
					{ "/breathtest", "/breathtest [player]", "Szonda alkoholra", "/breathtest [player]" },
					{ "/call", "/call [szám]", "Ezzel tudsz telefonálni", "/call 12444" },
					{ "/pickup", "/pickup", "Ezzel veszed fel a telefont", "/pickup" },
					{ "/p", "/p [üzenet]", "Suttogás a telefonba", "/p Hogy vagy?" },
					{ "/loudspeaker", "/loudspeaker", "Telefont lehet kihangositani vele", "/loudspeaker" },
					{ "/togglephone", "/togglephone", "Ezzel kapcsolod ki/be a telefonod", "/togglephone" },
					{ "/sms", "/sms [szám] [üzenet]","Ezzel tudsz sms-t küldeni"},
				},
				{
					name = "Munka",
					{ "/startbus", "/startbus", "Ezzel kezded el a buszos munkát", "/startbus" },
					{ "/fish", "/fish", "Ezzel kezdesz el halászni.", "/fish" },
					{ "/totalcatch", "/totalcatch", "Ezzel tudod megnézni mennyi halat fogtál", "/totalcatch" },
					{ "/sellfish", "/sellfish", "Ezzel tudod eladni a fogott halat", "/sellfish" },
					{ "/copykey", "/copykey [tipus] [id]", "Ezzel tudsz kulcsot másolni", "/copykey 1 50" },
					{ "/totalvalue", "/totalvalue", "Megmutatja a gyüjtemény értékét a vett képeknek.", "/totalvalue" },
					{ "/endjob vagy /quitjob", "/endjob vagy /quitjob", "Ezzel lépsz ki a munkából", "/endjob" },
					
				},
				{
					name = "Egyéb",
					{ "/?", "/?", "Megmutatja az alap segitséget", "/?" },
					{ "'M' vagy /togglecursvagy", "Nyomj 'M' gombot /togglecursvagy", "Ezzel hivod elő a kurzort", "'M' vagy /togglecursvagy" },
					{ "'O'", "Nyomj 'O' vagy  /friends", "Toggles your friends list.", "'O' vagy /friends" },
					{ "'R' vagy /reload", "Nyomj 'R'", "Ezzel töltöd ujra a fegyvert", "'R' vagy /reload" },
					{ "'F1'", "Nyomj 'F1'", "Ezzel nézed meg az alap leirást", "'F1'" },
					{ "'Tab'", "Keep 'Tab' Nyomj", "Ezzel nézed meg az id-d nevet meg a pinged", "'Tab'" },
					{ "'N'", "Nyomj 'N'", "Changes your Desert Eagle/Shotgun mode.", "'N'" },
					{ "'F6'", "Nyomj 'F6'", "Shows the languages menu.", "'F6'" },
					{ "/togglespeedo", "/togglespeedo", "Enables vagy disables the speedometer.", "/togglespeedo" },
					{ "/togglelaser", "/togglelaser", "Toggles your weapon laser.", "/togglelaser" },
					{ "/clearchat", "/clearchat", "Clears your chatbox' content.", "/clearchat" },
					{ "/id", "/id [player]", "Shows the ID and name fvagy a player with the given name/ID.", "/id Jessica_Keynes" },
					{ "/saveme", "/saveme", "Saves your current position and stats on the server, only do manually if you're bugged.", "/saveme" },
					{ "/settag", "/settag [1-8]", "Changes the tag you're spraying with a spraycan.", "/settag 2" },
					{ "/animlist", "/animlist", "Shows a list of animations.", "/animlist" },
					{ "/look", "/look [player]", "Shows age, race and a description of that character.", "/look Nathan_Daniels" },
					{ "/editlook", "/editlook", "Allows you to edit your character's look.", "/look Nathan_Daniels" },
					{ "/charity", "/charity [amount]", "Donates money to the hungry vagyphans.", "/charity 1337" },
					{ "/admins", "/admins", "Shows a list of all admins online and whetever they are on duty.", "/admins" },
					{ "/pay", "/pay [player] [amount]", "Gives the player some money from your wallet.", "/pay Ari_Viere 400" },
					{ "/stats", "/stats", "Shows your hours played, house ids, vehicle ids, languages etc.", "/stats" },
					{ "/timesaved", "/timesaved", "Shows how much time you have left until another payday will get you money.", "/timesaved" },
					{ "/gate", "/gate", "Opens various dovagys, some might require faction membership, a badge vagy a passwvagyd", "/gate" },
					{ "/glue", "/glue", "Glues yourself vagy the vehicle you're driving to the nearest vehicle.", "/glue" },
					{ "/showfps", "/showfps", "Toggles the FPS counter.", "/showfps" },
					{ "/fp vagy cockpit", "/fp vagy /cockpit", "Toggles cockpit view.", "/cockpit" },
					{ "/showlicenses", "/showlicenses [player]", "Shows your driving and gun license to the player.", "/showlicenses Darren_Baker" },
				}
			}
			--[[
				icreaterow = guiGridListAddRow ( chatcommandslist )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommand, "/i", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommanduse, "/i <IC text>", false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexplanation, "This allows an interviewee to participate in the interview." , false, false )
				guiGridListSetItemText ( chatcommandslist, icreaterow, chatcommandexample, "/i At that time, I never thought my idea would be so successful.", false, false )
				]]
			
			for _, levelcmds in pairs( commands ) do
				local tab = guiCreateTab( levelcmds.name, tabPanel)
				local list = guiCreateGridList(0.02, 0.02, 0.96, 0.96, true, tab)
				guiGridListAddColumn (list, "Command", 0.15)
				guiGridListAddColumn (list, "Use", 0.2)
				guiGridListAddColumn (list, "Explanation", 0.5)
				guiGridListAddColumn (list, "Example", 0.7)
				for _, command in ipairs( levelcmds ) do
					local row = guiGridListAddRow ( list )
					guiGridListSetItemText ( list, row, 1, command[1], false, false)
					guiGridListSetItemText ( list, row, 2, command[2], false, false)
					guiGridListSetItemText ( list, row, 3, command[3], false, false)
					guiGridListSetItemText ( list, row, 4, command[4], false, false)
				end
			end
			
			addEventHandler ("onClientGUIClick", tlBackButton, function(button, state)
				if (button == "left") then
					if (state == "up") then
						guiSetVisible(myCommandsWindow, false)
						showCursor (false)
						guiSetInputEnabled(false)
						myCommandsWindow = nil
					end
				end
			end, false)

			guiBringToFront (tlBackButton)
			guiSetVisible (myadminWindow, true)
		else
			local visible = guiGetVisible (myCommandsWindow)
			if (visible == false) then
				guiSetVisible( myCommandsWindow, true)
				showCursor (true)
			else
				showCursor(false)
			end
		end
	end
end
addCommandHandler("segitseg", commandsHelp)