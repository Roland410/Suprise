addEvent("hangLejatszas", true )



function zeneoff()
	stopSound (loginzene)
end


function valami()
		loginzene = playSound3D("alarm.mp3",1719.9000244141, -1130.3000488281, 24.39999961853,  true)
		setSoundMaxDistance (loginzene, 400)
        setElementDimension( loginzene, 0 )
        setElementInterior( loginzene , 0 )
		setTimer(zeneoff, 300000, 1)
end
addEventHandler("hangLejatszas", root, valami )