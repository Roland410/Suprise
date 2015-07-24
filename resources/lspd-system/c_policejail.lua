local Fitz = createPed(288, 195.68847656625, 159.880859375, 1003.0234375)
setPedRotation(Fitz, 180)
setElementDimension(Fitz, 1)
setElementInterior(Fitz, 3)
setElementData( Fitz, "talk", 1 )
setElementData( Fitz, "name", "Bobby Fitzgerald", false )
exports.global:applyAnimation( Fitz, "FOOD", "FF_Sit_Look", -1, true, false, true)
setElementFrozen( Fitz, true)


local marker = createMarker(2244.4982910156, -1664.8819580078, 14.4765625, "cylinder", 2, 0, 155, 255, 30)
local blip = createBlip ( 2244.4982910156, -1664.8819580078, 15.4765625, 45 )


GUIEditor = {

    label = {}

}

ventana = guiCreateGridList(0.33, 0.28, 0.34, 0.34, true)

guiSetAlpha(ventana, 0.85)
guiSetVisible ( ventana, false )



GUIEditor.label[1] = guiCreateLabel(0.31, 0.00, 0.47, 0.21, "Ruhabolt", true, ventana)

guiSetFont(GUIEditor.label[1], "sa-header")


GUIEditor.label[2] = guiCreateLabel(0.24, 0.27, 0.46, 0.11, "Ruha(skin) ID:", true, ventana)

guiSetFont(GUIEditor.label[2], "default-bold-small")

guiLabelSetColor(GUIEditor.label[2], 41, 183, 3)


edit = guiCreateEdit(0.15, 0.40, 0.30, 0.14, "", true, ventana)


cerrar = guiCreateButton(0.90, 0.02, 0.07, 0.11, "X", true, ventana)

tomar = guiCreateButton(0.30, 0.69, 0.44, 0.18, "Ruha Megvásárol", true, ventana)


GUIEditor.label[3] = guiCreateLabel(0.66, 0.25, 0.28, 0.37, "    Ruha Ára:\n\n     30000 Ft", true, ventana)

guiSetFont(GUIEditor.label[3], "default-bold-small")

guiLabelSetColor(GUIEditor.label[3], 27, 187, 227)

function abrir ( hitElement )
if getElementType(hitElement) == "player" and (hitElement == localPlayer) then
guiSetVisible(ventana, true)
showCursor(true)
outputChatBox ( "Üdvözöljük a ruhaboltban!", 255, 0, 0 )
end
end
addEventHandler("onClientMarkerHit", marker, abrir)

function cerrarv()
    guiSetVisible ( ventana, false )
    showCursor ( false )
    guiSetInputEnabled ( false )
end
addEventHandler("onClientGUIClick", cerrar, cerrarv, false)

function darskin()
local pMoney = getPlayerMoney(source)
if pMoney >= 30000 then
takePlayerMoney ( 30000 )
setPlayerSkin(localPlayer, tonumber( guiGetText ( edit ) ))
outputChatBox ( "sikeresen megevetted a ruhát!", 0, 255, 0 )
else
outputChatBox ( "Nincs elég pénzed!", 255, 0, 0 )
end
end
addEventHandler("onClientGUIClick", tomar, darskin, false)

