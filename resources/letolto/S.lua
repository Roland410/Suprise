dawnlodetext1 = "  Üdvözlünk a szerveren" --- the text up
dawnlodetext2 = " Kérlek várj míg letölt mindent" --- the text in medium
dawnlodetext3 = "Üdvözlettel Flymta" --- the text under




dis = textCreateDisplay()
screentext = textCreateTextItem(dawnlodetext1,0.2,0.2,"medium",255,0,0,255,3)
textDisplayAddText(dis,screentext)


dis1 = textCreateDisplay()
screentext1 = textCreateTextItem(dawnlodetext2,0.3,0.4,"medium",0,255,0,255,3)
textDisplayAddText(dis1,screentext1)


dis2 = textCreateDisplay()
screentext2 = textCreateTextItem(dawnlodetext3,0.4,0.6,"medium",255,255,0,255,3)
textDisplayAddText(dis2,screentext2)



addEventHandler("onResourceStart",resourceRoot,
    function ()
        for i,p in ipairs(getElementsByType("player")) do
            textDisplayAddObserver(dis,p)
            textDisplayAddObserver(dis1,p)
            textDisplayAddObserver(dis2,p)
        end
    end
)
 



addEventHandler("onPlayerJoin",root,
    function ()
        
	 fadeCamera(source, true, 5)
	setCameraMatrix(source, 1468.8785400391, -919.25317382813, 100.153465271, 1468.388671875, -918.42474365234, 99.881813049316)
        textDisplayAddObserver(dis,source)
        textDisplayAddObserver(dis1,source)
        textDisplayAddObserver(dis2,source)
    end
)



 
addEvent("removeText",true)
addEventHandler("removeText",root,
    function ()
        textDisplayRemoveObserver(dis,source)
        textDisplayRemoveObserver(dis1,source)
        textDisplayRemoveObserver(dis2,source)
    end
)
 



