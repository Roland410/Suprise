---------------------
-- www.lspd.gov --
---------------------
function www_rendorseg_hu()
	local page_length = 350
	
	guiSetText(internet_address_label, "Los Santos és Las Venturas Rendőrség - Mindent a törvény és a biztonyság érdekében! TEL: 107 ")
	guiSetText(address_bar,"www.rendorseg.hu")
	
	bg = guiCreateStaticImage(0,0,660,page_length,"websites/colours/10.png",false,internet_pane)
	
	local logo = guiCreateStaticImage(50,10,150,150,"websites/images/lspd-logo.png",false,bg)
	local header = guiCreateLabel(230,75,460,20,"Los Santos és Las Venturas Rendőrség",false,bg)
	
	local text = guiCreateLabel(100,200,450,165,"A FLYMTA Rendőrség minden erővel a városunk védésére törekszik.\
	                                        \
											A Rendőrség LS illetve LV-ben található. Iroda, Garázs, Öltözők stb.\
											\
											A városon belül taláható Járőr és Tek-es osztag egyaránt.\
											\
											Ha bajvan csak tárcsászd a 107-et és azonnal indulunk!\
											\
											Ha szeretnél jelentkezni érzed hogy telennél a legjobb rendőr jelentkezz E-Mail!",false,bg)
	guiSetFont(text,"default-bold-small")
	
----------------------------------------------------------------------
	if(page_length>=397)then
		guiScrollPaneSetScrollBars(internet_pane,false,true)
		guiScrollPaneSetVerticalScrollPosition(internet_pane,0)
	else
		guiSetSize(bg,660,397,false)
		guiScrollPaneSetScrollBars(internet_pane, false, false)
	end
end


