myWindow = nil
pressed = false

function bindKeys()
	bindKey("F1", "down", F1RPhelp)
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function resetState()
	pressed = false
end

function F1RPhelp( key, keyState )
	if not (pressed) then
		pressed = true
		setTimer(resetState, 200, 1)
		if ( myWindow == nil ) then		
			local xmlServerRules = xmlLoadFile( "help/serverrules.xml" )
			local xmlExplained = xmlLoadFile( "help/whatisroleplaying.xml" )
			local xmlOverview = xmlLoadFile( "help/overview.xml" )
			local xmlChangelog = xmlLoadFile( "help/changelog.xml" )
			
			myWindow = guiCreateWindow ( 0.25, 0.25, 0.5, 0.5, "Flymta - F1 segítség", true )
			local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
			
			local tabRules = guiCreateTab( "Szabályok", tabPanel )
			local memoRules = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlServerRules ), true, tabRules )
			guiMemoSetReadOnly(memoRules, true)
			
			local tabExplained = guiCreateTab( "Fogalmak", tabPanel )
			local memoExplained = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlExplained ), true, tabExplained )
			guiMemoSetReadOnly(memoExplained, true)
			
			local tabOverview = guiCreateTab( "Parancsok", tabPanel )
			local memoOverview = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlOverview ), true, tabOverview )
			guiMemoSetReadOnly(memoOverview, true)
			
			local tabChangelog = guiCreateTab( "Changelog", tabPanel )
			local memoChangelog = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlChangelog ), true, tabChangelog )
			guiMemoSetReadOnly(memoChangelog, true)
			
			showCursor( true )
			
			xmlUnloadFile( xmlServerRules )
			xmlUnloadFile( xmlExplained )
			xmlUnloadFile( xmlOverview )
			xmlUnloadFile( xmlChangelog )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end