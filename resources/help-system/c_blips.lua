hb0 = createBlip(1726.8037, -1636.0263, 20.2168, 31, 2, 255, 0, 0, 255, 0, 300) -- hotel
hb1 = createBlip(1548.39783, -1704.55042, 27.38980, 30, 2, 255, 0, 0, 255, 0, 300) -- rendörség
hb2 = createBlip(1504.06702, -1772.09912, 32.42221, 40, 2, 255, 0, 0, 255, 0, 300) -- városháza
hb3 = createBlip(1161.11230, -1336.30334, 31.43797, 22, 2, 255, 0, 0, 255, 0, 300) -- korház
hb4 = createBlip(2233.84619, -1675.18604, 17.18005, 45, 2, 255, 0, 0, 255, 0, 300) -- ruhabolt
hb5 = createBlip(1850.26611, -1707.90271, 30.79152, 48, 2, 255, 0, 0, 255, 0, 300) -- diyzko
hb6 = createBlip(1845.20984, -1838.69067, 16.06237, 36, 2, 255, 0, 0, 255, 0, 300) -- oktato
hb7 = createBlip(329.27463, -1846.97559, 2.35918, 27, 2, 255, 0, 0, 255, 0, 300) -- szerelo
hb8 = createBlip(2233.47144, -1708.24524, 21.81598, 54, 2, 255, 0, 0, 255, 0, 300) -- tornaklub
hb9 = createBlip(1656.85376, -1659.49390, 21.50369, 44, 2, 255, 0, 0, 255, 0, 300) -- kaszino
hb10 = createBlip(531.08838, -1287.91968, 16.23342, 55, 2, 255, 0, 0, 255, 0, 300) -- autoker


function test1()
engineLoadIFP ( "covers.ifp")
end
addCommandHandler("load1", test1)

function test2(commandHandler, anim1, anim2)
setPedAnimation(getLocalPlayer(), anim1, anim2)
end
addCommandHandler("load2", test2)