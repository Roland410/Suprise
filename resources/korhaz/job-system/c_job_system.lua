wEmployment, jobList, bAcceptJob, bCancel = nil

local jessie = createPed( 141, 359.602539062,  173.5703125, 1008.3893432617)
--local judit = createPed( 141, 359.11392822266, 173.68501281738, 1008.3893432617 )
setElementFrozen(jessie, true)
setPedRotation( jessie, 270 )
setElementDimension( jessie, 734 )
setElementInterior( jessie , 3 )
setElementData( jessie, "talk", 1, false )
setElementData( jessie, "name", "Jessie Smith", false )
setPedAnimation ( jessie, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false )

function showEmploymentWindow()
	
	-- Employment Tooltip
	if(getResourceFromName("tooltips-system"))then
		triggerEvent("tooltips:showHelp",getLocalPlayer(),7)
	end
	
	triggerServerEvent("onEmploymentServer", getLocalPlayer())
	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wEmployment = guiCreateWindow(x, y, width, height, "Munkaközvetítő", false)
	
	jobList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, wEmployment)
	local column = guiGridListAddColumn(jobList, "Munka", 0.9)

	-- TRUCKER
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Futár", false, false)
	
	-- TAXI
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Taxis", false, false)
	
	-- BUS
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Buszsofőr", false, false)
	
	-- CITY MAINTENACE
	local team = getPlayerTeam(getLocalPlayer())
	local ftype = getElementData(team, "type")
	if ftype ~= 2 then
		local rowmaintenance = guiGridListAddRow(jobList)
		guiGridListSetItemText(jobList, rowmaintenance, column, "Közterület fenntartó", false, false)
	end
	
	-- MECHANIC
	--local row = guiGridListAddRow(jobList)
	--guiGridListSetItemText(jobList, row, column, "Szerelő", false, false)
	
	-- LOCKSMITH
	local row = guiGridListAddRow(jobList)
	guiGridListSetItemText(jobList, row, column, "Lakatos", false, false)
	
	bAcceptJob = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Szerződés", true, wEmployment)
	bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "Kilépés", true, wEmployment)
	
	showCursor(true)
	
	addEventHandler("onClientGUIClick", bAcceptJob, acceptJob)
	addEventHandler("onClientGUIDoubleClick", jobList, acceptJob)
	addEventHandler("onClientGUIClick", bCancel, cancelJob)
end
addEvent("onEmployment", true)
addEventHandler("onEmployment", getRootElement(), showEmploymentWindow)

function acceptJob(button, state)
	if (button=="left") then
		local row, col = guiGridListGetSelectedItem(jobList)
		local job = getElementData(getLocalPlayer(), "job")
		
		if (row==-1) or (col==-1) then
			outputChatBox("Válassz a munkalehetőségek közül!", 255, 0, 0)
		elseif (job>0) then
			outputChatBox("Már van munkaviszonyod! Ha szeretnél más munkát, akkor először mondj fel! (( /quitjob )).", 255, 0, 0)
		else
			local job = 0
			local jobtext = guiGridListGetItemText(jobList, guiGridListGetSelectedItem(jobList), 1)
			
			if ( jobtext=="Futár" or jobtext=="Taxis" or jobtext=="Buszsofőr" ) then  -- Driving job, requires the license
				local carlicense = getElementData(getLocalPlayer(), "license.car")
				if (carlicense~=1) then
					outputChatBox("A munkához járművezetői engedély szükséges!", 255, 0, 0)
					return
				end
			end
			
			if (jobtext=="Futár") then
				displayTruckerJob()
				job = 1
			elseif (jobtext=="Taxis") then
				job = 2
				displayTaxiJob()
			elseif  (jobtext=="Buszsofőr") then
				job = 3
				displayBusJob()
			elseif (jobtext=="Közterület fenntartó") then
				job = 4
			elseif (jobtext=="Szerelő") then
				displayMechanicJob()
				job = 5
			elseif (jobtext=="Lakatos") then
				displayLocksmithJob()
				job = 6
			end
			
			triggerServerEvent("acceptJob", getLocalPlayer(), job)
			
			destroyElement(jobList)
			destroyElement(bAcceptJob)
			destroyElement(bCancel)
			destroyElement(wEmployment)
			wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
			showCursor(false)
		end
	end
end

function cancelJob(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(jobList)
		destroyElement(bAcceptJob)
		destroyElement(bCancel)
		destroyElement(wEmployment)
		wEmployment, jobList, bAcceptJob, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end