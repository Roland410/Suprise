function applyMods()
local park = createPed( 21, 1448.0478, -1713.2099, 14.0468) --183 ra irni a dimensiot ha végeztem
setPedRotation( park, 94 )
setElementDimension( park, 0 )
setElementInterior( park , 0 )
setPedAnimation ( park, "DANCING", "DAN_Down_A", -1, true, false, false )
setElementFrozen(park, true)




end
addEventHandler("onClientResourceStart", getResourceRootElement(), applyMods)