--========================= TUTORIAL SCRIPT ==============================================

-- Concrete Gaming Roleplay Server - Tutorial and Quiz script for un-registerd players - written by Peter Gibbons (aka Jason Moore)

local tutorialStage = {}
	tutorialStage[1] = {1942.0830078125, -1738.974609375, 16.3828125, 1942.0830078125, -1760.5703125, 13.3828125} -- idlewood gas station//
	tutorialStage[2] = {1538.626953125, -1675.9375, 19.546875, 1553.8388671875, -1675.6708984375, 16.1953125} --LSPD//
	tutorialStage[3] = {2317.6123046875, -1664.6640625, 17.215812683105, 2317.4755859375, -1651.1640625, 17.221110343933} -- 10 green bottles//
	tutorialStage[4] = {1742.623046875, -1847.7109375, 16.579560279846, 1742.1884765625, -1861.3564453125, 13.577615737915} -- Unity Station//
	tutorialStage[5] = {1685.3681640625, -2309.9150390625, 16.546875, 1685.583984375, -2329.4443359375, 13.546875} -- Airport//
	tutorialStage[6] = {368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375} -- Pier//
	tutorialStage[7] = {1411.384765625, -870.787109375, 78.552024841309, 1415.9248046875, -810.15234375, 78.552024841309} -- Vinewood sign//
	tutorialStage[8] = {1893.955078125, -1165.79296875, 27.048973083496, 1960.4404296875, -1197.3486328125, 26.849721908569} -- Glen Park//
	tutorialStage[9] = {2817.37890625, -1865.7998046875, 14.219080924988, 2858.4248046875, -1849.91796875, 14.084205627441} -- East Beach
	
local stageTime = 15000
local fadeTime = 2000
local fadeDelay = 300

local tutorialTitles = {}
	tutorialTitles[1] = "Üdvözlünk"
	tutorialTitles[2] = "Te neved"
	tutorialTitles[3] = "Szerepjátékról"
	tutorialTitles[4] = "IC és OOC"
	tutorialTitles[5] = "Szerver Szabályzat"
	tutorialTitles[6] = "Bugok,Csalások"
	tutorialTitles[7] = "Nyelvek"
	tutorialTitles[8] = "Munkák"
	tutorialTitles[9] = "MORE INFORMATION"
	

local tutorialText = {}
		tutorialText[1] = {"Üdvözlünk a Fly Roleplay szerverén.",
					"Látom te új vagy itt, ezért kérem, Hadja,hogy 2 perc alatt,bemutassam Önnek a szervert.",
					"H bármi segitségre.több információra van szükséged fordulj bizalommal az adminokhoz,vagy látogass el a weboldalunkra www.flymta.eu"}
	
	tutorialText[2] = 		{"Szerepjáték (RP) egy játék,ahol a játékosok betöltheti az egy általa kitalált személy szerepét",
					"Keresztnév Vezetéknév. Ez bármi lehet, amit csak akarsz, például: Yamazaky Chang",}
	
	tutorialText[3] = 		{"Szerepjáték: Ez azt jelenti, meghatalmazotti minõségben, ahogy azt a ",
					"valós életben tennéd.",
					"Annak ellenére, hogy vannak a  szerveren frakciók, ezért szerepet játszhat, ahogy szeretne,",
					"feltéve, hogy követi a Szerver alapszabályokat."}
	
	tutorialText[4] = 		{"In Character (IC) és az Out of Character (OOC) alapvetõ fontosság a szerveren",
					"OOC:ide azt irjuk ami nem a játékkal kapcsolatos például:Jössz ts?",
					"Ezekkel tudunk OOC beszélni, parancsok: /o, /b és /pm.",
					"OOC ben való dolgokat kérjük ne keverd az IC fogalmakkal össze."}
	
	tutorialText[5] = 		{"Fontos a szerepjátékban a  kifejezések, hogy egyszerü legyen megérteni, a fogalmakat mint pl.:a'Metagaming'",
					"(OOC információ felhasználása IC inormációként),  'Powergaming' (Hõsködés pl.: fegyvert fognak rám én meg elfutok)",
					"További információért nyomja meg az f1 billentyüt és kiadja a többi segitséget",}
	
	tutorialText[6] = 		{"Szerveren Csalni TILOS.",
					"Bugot észleltek vagy csalót azonnal jelentsétek a játékélmény fenakadása miatt.",
					"Ezt két féle képp megtehetitek Szerverene:/report,weboldalon bug topic" }
					  
	tutorialText[7] = 		{"Szerveren több fajta idegen nyelvet meglehet tanulni.",
					"Angol nyelvet tanultál meg akkor aki spanyol nyelvet tud az nem érti Ic be amit beszélsz.",
					"OOC-be mindkét fél láthatja amit beszél nyelvtõl függetlenül",}
	
	tutorialText[8] = 		{"Munkát a Városházán az ügyintézõnél tudsz felvenni",
					"Szerveren több fajta munka lehetõség található amiböl kedvedre válogathatsz",}

				   
	tutorialText[9] = 	{"Információkkat a szerveren az f1 billentyüvel,milletve a /report parancsal tudsz kérni",
					"Veboldalunkon érdemes regisztrálni mivel ott folyamatosan nyomon követheted a fejlesztéseket.",
					"Bármiféle segitségre szorulsz írj nyugodtan egy adminnak és segit",}
					
					

-- function starts the tutorial
function showTutorial()

	local thePlayer = getLocalPlayer()

	-- set the player to not logged in so they don't see any other random chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
		
	-- if the player hasn't got an element data, set it to 1
	if not (getElementData(thePlayer, "tutorialStage")) then
		setElementData(thePlayer, "tutorialStage", 0, false)
	end
	
	-- ionc
	setElementData(thePlayer, "tutorialStage", getElementData(thePlayer, "tutorialStage")+1, false)

	
	-- stop the player from using any controls to move around or chat
	toggleAllControls (  false )
	-- fade the camera to black so they don't see the teleporting renders
	fadeCamera ( false, fadeTime/1000 ,0,0,0)
	
	-- timer to move the camera to the first location as soon as the screen has gone black.
	setTimer(function()
		
		-- timer to set camera position and fade in after the camera has faded out to black
		setTimer(function()
				
			local stage = getElementData(thePlayer, "tutorialStage")
			
			local camX = tutorialStage[stage][1]
			local camY = tutorialStage[stage][2]
			local camZ = tutorialStage[stage][3]
			local lookX = tutorialStage[stage][4]
			local lookY = tutorialStage[stage][5]
			local lookZ = tutorialStage[stage][6]
			
			setCameraMatrix(camX, camY, camZ, lookX, lookY, lookZ)
			
			-- set the element to outside and dimension 0 so they see th eother players
			setElementInterior(thePlayer, 0)
			setElementDimension(thePlayer, 0)
			
			-- fade the camera in
			fadeCamera( true, fadeTime/1000)
			
			-- call function to output the text
			outputTutorialText(stage)
			
			-- function to fade out after message has been displayed a read
			setTimer(function()
								
				local lastStage = getLastStage()
				
				-- if the player is on the last stage of the tutorial, fade their camera out and...
				if(stage == lastStage) then
					fadeCamera( false, fadeTime/1000, 0,0,0)
					
					setTimer(function()

						-- show the quiz after a certain time
						endTutorial()
						
						setElementData ( thePlayer, "tutorialStage", 0, false )
						
					end, fadeTime+fadeDelay,1 )
				else -- else more stages to go, show the next stage
					showTutorial(thePlayer)
				end
			end, stageTime, 1)
		end, 150, 1)
	end, fadeTime+fadeDelay , 1)
end



-- function returns the number of stages
function getLastStage()

	local lastStage = 0
	
	if(tutorialStage) then
		for i, j in pairs(tutorialStage) do
			lastStage = lastStage + 1
		end
	end
	
	return lastStage
end


-- function outputs the text during the tutorial
function outputTutorialText( stage)
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(" ")
	outputChatBox(tutorialTitles[stage],  255, 0,0, true)
	outputChatBox(" ")
	
	if(tutorialText[stage]) then
		for i, j in pairs(tutorialText[stage]) do
				outputChatBox(j)
		end
	end

end

-- function fade in the camera and sets the player to the quiz room so they can do the quiz
function endTutorial()

	local thePlayer = getLocalPlayer()
	
	-- set the player to not logged in so they don't see the chat
	triggerServerEvent("player:loggedout", getLocalPlayer())
	toggleAllControls(false)
			
	
	setTimer(function()
		setCameraMatrix(368.0419921875, -2008.1494140625, 7.671875, 383.765625, -2020.935546875, 10.8359375)
		
		-- fade the players camera in
		fadeCamera(true, 2)
		
		-- trigger the client to start showing the quiz
		setTimer(function()
			triggerEvent("onClientStartQuiz", thePlayer)
			
		end, 2000, 1)
		
		
	end, 100, 1)

end




   ------------ TUTORIAL QUIZ SECTION - SCRIPTED BY PETER GIBBONS, AKA JASON MOORE --------------
   
   
   
   questions = { }
questions[1] = {"Mit jelent az RP?", "Idiótajáték", "Szerepjáték", "Felvétel", "Csalás", 2}
questions[2] = {"Szabad a szerverhirdetés?", "Igen /ad", "Igen /reportba adminnak", " Igen OOC chatben", "Soha mert bannolnak", 4}
questions[3] = {"Mi a teendõ, ha látod, hogy valaki Csal?", "Azonnal jelentem egy adminnak /report", "Oda se figyelek", "Én is neki állok csalni", "Mekérem,hogy segitsen nekem is csalni", 1}
questions[4] = {"Mi a címe a weboldalnak és fórumnak?", "www.google.hu", "www.freemail.hu", "www.flymta.eu", "www.fly.hu", 3} 
questions[5] = {"El szeretnék jutni egyik helyrõl a másikra mit teszek?", "Hívok egy admint,hogy teleportáljon oda", "Hívok egy taxit és elvitetem magam", "Bekapcsolom a csalást", "Lopok egy kocsit és azzal megyek oda", 2}
questions[6] = {"Melyik a helyes Név a szerveren", "Vezetéknév", "Vezetéknév Keresztnév", "Keresztnév Vezetéknév", "Bármi lehet", 2}
questions[7] = {"Szerinted melyik a helyes név a szerveren", "Bunko_Pista", "Niko Harrison", "asd 150", "bármi lehet", 2}
questions[8] = {"Mikor kell Rp-ni a szerveren", "Mindig", "Soha", "Csak ha admin figyel", 1}
questions[9] = {"Mit kell tenni ha ütközünk?", "Semmit tovább megyek", "Mégegyszer megcsinálom", "OOC be leirom mi történt", "/me beverte a fejét", 4}
questions[10] = {"Csatlakozni szeretnék egy szervezethez mit kell tennem?", "Szólok egy adminnak tegyen be a szervezetbe", "OOC-be megirod nekik,hogy vegyenek be", "Szépen le rp-zem ahogy illik", "semmit nem csinálok", 3}
questions[11] = {"Mit jelent az OOC?", "Trafipaxx", "Szerepen kivüli dolgok", "Tankolás", "Igyunk egy kávét", 2}
questions[12] = {"Mit jelent az IC?", "Szerepen belüli dolgok", "Kocsikulcs", "Csalást", "Semmit", 1}
questions[13] = {"Mit jelent az Metagaming", "Ok nélküli ölés", "Hõsködés", "Száguldozást", "OOC adatok Ic-ben való felhasználása", 4}
questions[14] = {"Milyen nyelven van a szerver", "Francia", "Magyar", "Héber", "Latin", 2}
questions[15] = {"Mikor beszél egy másik játékos az Ön anyanyelvén?", "Ha kitanulta", "Csak OOC-be", "Soha.", 1}
questions[16] = {"Mitjelent a DM?", "Szerepjáték", "Ok nélüli ölés", "Nincs autom", "Eggyiksem", 2}
questions[17] = {"Mit jelent a PG?", "Hõsködés", "OOC-Chat", "Gyilkolás", "Bankrablás", 1}

-- variable for the max number of possible questions
local NoQuestions = 17
local NoQuestionToAnswer = 10
local correctAnswers = 0
local passPercent = 90
		
selection = {}


-- functon makes the intro window for the quiz
function createQuizIntroWindow()

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Rp-teszt" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindow)
	
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, "	Akkor most következzék az a teszt\
										 ", true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center")
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Teszt Indul" , true ,guiIntroWindow)
	
	guiSetVisible(guiIntroWindow, true)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startQuiz()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)

end


-- function create the question window
function createQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Question "..number.." of "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.1, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.3, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	if not(selection[number][5] == "nil") then
		guiQuestionAnswer4Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][5], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Next Question" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Submit Answers" , true ,guiQuestionWindow)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][6]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createFinishQuizWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createFinishQuizWindow()

	local score = (correctAnswers/NoQuestionToAnswer)*100

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "End of Quiz", false )
	
	if(score >= passPercent) then
	
		local xmlRoot = xmlCreateFile("vgrptut.xml", "passedtutorial")
		xmlSaveFile(xmlRoot)
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Congratulations! You have passed!", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..score.."%, and the pass mark is "..passPercent.."%. Well done!\
											Please remember to register at the forums (www.mta.vg)\
											if you have not done so.\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center")
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continue" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				toggleAllControls ( true )
				triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
				if createXMB then
					createXMB()
				else
					createMainUI(getThisResource())
				end
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Sorry, you have not passed this time.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "You scored "..math.ceil(score).."%, and the pass mark is "..passPercent.."%.\
											You can retake the quiz as many times as you like, so have another shot!\
											\
											Thank you for playing at Valhalla Gaming MTA!" ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center")
		
		guiFinalRetakeButton = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Take Quiz Again" , true ,guiFinishWindow)
		guiFinalTutorialButton = guiCreateButton ( 0.55 , 0.8 , 0.25, 0.1 , "Show Tutorial" , true ,guiFinishWindow)
		
		-- if player click the retake button
		addEventHandler ( "onClientGUIClick", guiFinalRetakeButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				startShowQuizIntro()
			end
		end, false)
		
		-- if player click the show tutorial
		addEventHandler ( "onClientGUIClick", guiFinalTutorialButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- reset their correct answers and hide the window
				correctAnswers = 0
				guiSetVisible(guiFinishWindow, false)
				guiSetInputEnabled(false)
				
				-- trigger server event to show the tutorial
				showTutorial()
			end
		end, false)
	
	
	
	end

end


-- function is triggerd by the server when it is time for the player to take the quiz
function startShowQuizIntro()
	
	clearChatBox()
	-- reset the players correct answers to 0
	correctAnswers = 0
	-- create the intro window
	createQuizIntroWindow()
	-- Set input enabled
	guiSetInputEnabled(true)

end
 addEvent("onClientStartQuiz", true)
 addEventHandler( "onClientStartQuiz", getLocalPlayer() ,  startShowQuizIntro)
 
 
 -- function starts the quiz
 function startQuiz()
 
	-- choose a random set of questions
	chooseQuizQuestions()
	-- create the question window with question number 1
	createQuestionWindow(1)
 
 end
 
 
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseQuizQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(questionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (questionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function questionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
  
 end