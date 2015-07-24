function kradio(jatekos)
    local kocsiban = getPedOccupiedVehicle(jatekos)
	local munka = getElementData(jatekos, "job")
	
	
	if kocsiban then 
	outputChatBox( "Bekapcsoltad a kocsiradiot", jatekos, 0, 255, 0 )
	triggerClientEvent ( "kocsiradio", getRootElement())
    else
	outputChatBox( "Nem ülsz kocsiban", jatekos, 255, 0, 0 )

end
end
addCommandHandler("kradio", kradio)



function radioki (jatekos)
  outputChatBox( "Kikapcsoltad a kocsiradiot", jatekos, 0, 255, 0 )
  end
addEvent( "rdioki", true )
addEventHandler( "rdioki", root,radioki )

function neo (jatekos)
  outputChatBox( "Átváltottad a radiot Neofm csatornára", jatekos, 0, 255, 0 )
  local kocsiban = getPedOccupiedVehicle(jatekos)
	
	if kocsiban then 
	
  end
  end
addEvent( "nfmbe", true )
addEventHandler( "nfmbe", root,neo  )