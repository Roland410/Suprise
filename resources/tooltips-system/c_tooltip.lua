
xmlfileok = {
	"welcome.xml",       -- 1
	"vehicles.xml",      -- 2
	"weapons.xml",       -- 3
	"interiors.xml",     -- 4
	"shops.xml",         -- 5
	"npcs.xml",          -- 6
	"jobs.xml",          -- 7
	"languages.xml",     -- 8
	"factions.xml",      -- 9
	"death.xml",         -- 10
	"vehicle_buying.xml",-- 11
	"pay_check.xml",     -- 12
	"computers.xml",     -- 13
	"inventory.xml",     -- 14
 	"houses.xml",        -- 15
	"gas_stations.xml",  -- 16
	"chat.xml",          -- 17
	"injuries.xml",      -- 18
}


xmlGrids = {}
local scrX, scrY = guiGetScreenSize()
local xmlw = false
local RHWindow,RHList,wHelp

function showXmlList()
  if xmlw == false then
    RHWindow = guiCreateWindow ( scrX/2-200 ,  scrY/2-250 , 400, 500, "RP leírások", false )
	RHList = guiCreateGridList (  5, 20, 390, 450, false, RHWindow )
	RHColum = guiGridListAddColumn ( RHList, "Témák", 0.9 )
	RHOpenButton = guiCreateButton ( 105, 475, 70, 20, "Megnéz", false, RHWindow )
	RHCloseButton = guiCreateButton ( 205, 475, 70, 20, "Bezár", false, RHWindow )
	    for i = 1 , #xmlfileok , 1 do
	              local xml = xmlLoadFile ("text/"..xmlfileok[i])
                  local child = xmlFindChild( xml, "title", 0) 						 
                  local RHListTitle = xmlNodeGetValue(child)
				  xmlGrids[i] = guiGridListAddRow (RHList)
				  guiGridListSetItemText(RHList, xmlGrids[i], RHColum, tostring(RHListTitle), false, false)
 		end		
        showCursor(true)	
        xmlw = true		
	addEventHandler("onClientGUIClick",RHCloseButton,function ()
                                                            destroyElement(RHWindow)
                                                            showCursor(false)
	                                                        xmlw = false  
                                                     end	)	
	addEventHandler("onClientGUIClick", RHOpenButton,  OpenSelectedGrid)												 
  else
    destroyElement(RHWindow)
    showCursor(false)
	xmlw = false
  end	
 end
 addCommandHandler("rphelp",showXmlList)
 
function OpenSelectedGrid()
    index = guiGridListGetSelectedItem(RHList)
	index = index + 1
	xmlw = false
	
	if index == 0 then
	   return outputChatBox ("Előbb válassz ki egy elemet!", 255, 0, 0)
	end 
	
    destroyElement(RHWindow)
    showCursor(false)
	
	if not (wHelp) then
		local xml = xmlLoadFile( "text/"..xmlfileok[index] )
		if (xml) then
			local content = xmlNodeGetValue(xmlFindChild (xml, "text", 0))
			local pageLength = tonumber(xmlNodeGetValue(xmlFindChild (xml, "pageLength", 0)))
			xmlUnloadFile( xml )
			
			local Width = 500
			local Height = 400
			
			local X = (scrX - Width)/2
			local Y = (scrY - Height)/2
			
			wHelp = guiCreateWindow(X, Y, Width, Height, "Segítség", false)
			
			help_title_text = guiCreateLabel(10,30,396,30,title,false,wHelp)
			guiSetFont(help_title_text,"default-bold-small")
			
			help_scroll = guiCreateScrollPane(0,50,500,300,false,wHelp)
			
			help_text = guiCreateLabel(2,0,455,pageLength,content,false,help_scroll)
			guiLabelSetHorizontalAlign(help_text,"left",true)
			
			help_close_button = guiCreateButton(200,357,100,40,"Bezárás",false,wHelp)
			
			showCursor(true)
			
			local page_x, page_y = guiGetSize(help_text, false)
			if (page_y>300) then
				guiScrollPaneSetScrollBars(help_scroll,false,true)
			end
			addEventHandler("onClientGUIClick",help_close_button,function ()
                                                                   destroyElement(wHelp)
                                                                    showCursor(false)
																	wHelp = nil
                                                                  end	)	
			
			
		end
	end	
end 