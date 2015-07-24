function autoAllitas( )
	local id = getElementModel( source )
	if id == 427 then--Rendő Merci Szállító - Enforcer
		setVehicleHandling( source, "maxVelocity", 150 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 20 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.85 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.1 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )		
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
		setVehicleHandling( source, "driveType", "awd") --- végsebesség most 500
	elseif id == 445 then--lADA
		setVehicleHandling( source, "maxVelocity", 120 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 12 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
		setVehicleHandling( source, "driveType", "rwd") --- végsebesség most 500
		-- ide ird h mit szeretnél a 420 id-jün változtatni, az elözö sor csak egy példa
	elseif id == 546 then--- BMW 540 I
		setVehicleHandling( source, "maxVelocity", 210 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 27 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.2 ) --- fékezés most 2			
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )		
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
		setVehicleHandling( source, "driveType", "fwd") --- végsebesség most 500
	---elseif id == 516 then
		-- stb...
	elseif id == 596 then---rendőrauto MITSUBISHI
		setVehicleHandling( source, "mass", 1320) -- tömeg kg"turnMass", 3780
		setVehicleHandling( source, "turnMass", 3320)
		setVehicleHandling( source, "maxVelocity", 240 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.95) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.05 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )
		setVehicleHandling( source, "suspensionForceLevel", 2.5)--kerék-karosszéria táv növelés  plusz pattogás
		--setVehicleHandling( source, "suspensionFrontRearBias", 0.5) --Dőlésszög az eleje és hátulja között
		setVehicleHandling( source, "driveType", "awd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "petrol") --- végsebesség most 500
		setVehicleHandling( source, "numberOfGears", 5)-- sebességek min 1 - max 5
	---elseif id == 516 then
		-- stb...
	elseif id == 597 then--- OMSZ Opel Vectra
		setVehicleHandling( source, "maxVelocity", 189 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 24 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )		
		setVehicleHandling( source, "driveType", "fwd") --- végsebesség most 500
	---elseif id == 516 then
		-- stb...
    elseif id == 402 then --Astonmartin
		setVehicleHandling( source, "maxVelocity", 240 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.5 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		
	elseif id == 599 then --Mitsubitshi terepjáró
		setVehicleHandling( source, "maxVelocity", 180 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 23 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
	elseif id == 579 then --BMW x6
		setVehicleHandling( source, "mass", 2200 ) -- tömeg kg		
		setVehicleHandling( source, "turnMass", 5000)
		setVehicleHandling( source, "maxVelocity", 240 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 25  ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 1.0 )
		setVehicleHandling( source, "tractionLoss", 0.75 ) --- tapadás
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -1.1} )
		setVehicleHandling( source, "numberOfGears", 5)-- sebességek min 1 - max 5)
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500		
		setVehicleHandling( source, "driveType", "awd")
	elseif id == 451 then --Ferrari
		setVehicleHandling( source, "maxVelocity", 280 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 35 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
	elseif id == 401 then --Fiat
		setVehicleHandling( source, "maxVelocity", 140 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 20 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.55 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
	elseif id == 400 then --Nissan
		setVehicleHandling( source, "maxVelocity", 170 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 24 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
	elseif id == 405 then --Audi A6
		setVehicleHandling( source, "maxVelocity", 260 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 1.2 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 0.9 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		setVehicleHandling( source, "driveType", "awd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
	elseif id == 409 then -- Limuzin - Stretch 
		setVehicleHandling( source, "suspensionDamping", 0 ) --- végsebesség most 500
		setVehicleHandling( source, "maxVelocity", 180 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 25 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.5 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )
		setVehicleHandling( source, "suspensionForceLevel", 2.5)--kerék-karosszéria táv növelés  plusz pattogás
		--setVehicleHandling( source, "suspensionFrontRearBias", 0.5) --Dőlésszög az eleje és hátulja között
		setVehicleHandling( source, "driveType", "awd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "petrol") --- végsebesség most 500
		setVehicleHandling( source, "numberOfGears", 5)-- sebességek min 1 - max 5
	elseif id == 411 then -- Bugatti Veyron	
		setVehicleHandling( source, "mass", 1888 ) -- tömeg kg
		setVehicleHandling( source, "maxVelocity", 408.3 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 40 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 1.2 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2.2 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )
	elseif id == 410 then -- Mini cupe 
		setVehicleHandling( source, "maxVelocity", 140 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 25 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.6 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
	elseif id == 421 then --Boxer
		setVehicleHandling( source, "maxVelocity", 160 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
	---elseif id == 516 then
	elseif id == 415 then -- MClaren F1
		setVehicleHandling( source, "mass", 1138 ) -- tömeg kg
		setVehicleHandling( source, "maxVelocity", 391 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 43 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 1 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )
		setVehicleHandling( source, "driveType", "awd") --- végsebesség most 500
	
		-- stb... 		
	elseif id == 422 then --GMC Terepjáró
		setVehicleHandling( source, "maxVelocity", 140 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 20 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.45 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
	---elseif id == 516 then
		-- stb... 
	elseif id == 426 then --Mercedes C350
		setVehicleHandling( source, "maxVelocity", 190 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 28 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.5 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		setVehicleHandling( source, "driveType", "rwd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
	---elseif id == 516 then
	elseif id == 436 then --Seat Leon
		setVehicleHandling( source, "maxVelocity", 170 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration",22  ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.45 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
	---elseif id == 516 then
	elseif id == 429 then --Porshe 
		setVehicleHandling( source, "maxVelocity",250  ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 34 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.62 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
	
	elseif id == 470 then --Hammer, Hummer, Patriot
		setVehicleHandling( source, "maxVelocity", 170 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 24 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.45 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.2 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )
	elseif id == 475 then -- Ford Mustang - Sabre - régi
		setVehicleHandling( source, "maxVelocity", 230 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.6 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.5 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		setVehicleHandling( source, "driveType", "rwd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
	elseif id == 492 then --opel vectra
		setVehicleHandling( source, "maxVelocity", 190 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 23 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.75 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.2 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )		
		setVehicleHandling( source, "driveType", "fwd") --- végsebesség most 500
	
	elseif id == 517 then -- Renault Megan
		setVehicleHandling( source, "maxVelocity", 160 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 18 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.4 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		
		elseif id == 480 then -- Lambogini cabrio
		setVehicleHandling( source, "maxVelocity", 270 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 33 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		elseif id == 413 then -- Ford tranzit
		setVehicleHandling( source, "maxVelocity", 140 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 18 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.5 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		elseif id == 560 then -- Lexus
		setVehicleHandling( source, "maxVelocity", 235 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 27 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2	
		
		elseif id == 541 then -- Chevrolette Camaro - Bullet
		setVehicleHandling( source, "maxVelocity", 250 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 34 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.6 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
	
		elseif id == 602 then -- Ford Mustang - új
		setVehicleHandling( source, "maxVelocity", 220 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 28 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.3 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		setVehicleHandling( source, "driveType", "rwd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
		
		elseif id == 598 then -- OMSZ Opel Vectra
		setVehicleHandling( source, "maxVelocity", 190 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 25 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.3 ) --- fékezés most 2				
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.5} )		
		setVehicleHandling( source, "driveType", "fwd") --- végsebesség most 500
		
		elseif id == 587 then -- m3 bmw
		setVehicleHandling( source, "maxVelocity", 210 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 29 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.6 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		
		elseif id == 589 then -- toyota
		setVehicleHandling( source, "maxVelocity", 180 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 27 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.7 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		
		elseif id == 477 then -- dogdge charger  zr-350
		setVehicleHandling( source, "maxVelocity", 220 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 30 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.65 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.5 ) --- fékezés most 2
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		setVehicleHandling( source, "driveType", "rwd") --- végsebesség most 500
		setVehicleHandling( source, "engineType", "diesel") --- végsebesség most 500
		elseif id == 439 then -- mazda
		setVehicleHandling( source, "maxVelocity", 150 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 18 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.52 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 2 ) --- fékezés most 2
		elseif id == 479 then -- dachia
		setVehicleHandling( source, "maxVelocity", 150 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 20 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.75 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.3 ) --- fékezés most 2		
		setVehicleHandling( source, "centerOfMass", {0.0, 0.1, -0.4} )
		elseif id == 500 then -- toyota terep
		setVehicleHandling( source, "maxVelocity", 140 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 15 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.6 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1 ) --- fékezés most 2
		
		elseif id == 565 then -- audi A3
		setVehicleHandling( source, "maxVelocity", 190 ) --- végsebesség most 500
		setVehicleHandling( source, "engineAcceleration", 28 ) --- gyorsulás most 30
		setVehicleHandling( source, "tractionMultiplier", 0.8 ) --- kanyarodás most 0.5
		setVehicleHandling( source, "tractionLoss", 1.5 ) --- fékezés most 2
	
	end
end

addEventHandler( "onVehicleEnter", getRootElement(), autoAllitas )