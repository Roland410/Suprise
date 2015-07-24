function cPayDay(faction, pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome)
	-- output payslip
	outputChatBox("-------------------------- FIZETÉS ---------------------------", 255, 194, 14)
		
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 0) then
			outputChatBox("    Állami juttatások: #00FF00Ft" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	else
		if (pay + tax > 0) then
			outputChatBox("    Fizetett bér: #00FF00Ft" .. exports.global:formatMoney(pay+tax), 255, 194, 14, true)
		end
	end
	
	-- business profit
	if (profit > 0) then
		outputChatBox("    Biznisz nyereség: #00FF00Ft" .. exports.global:formatMoney(profit), 255, 194, 14, true)
	end
	
	-- bank interest
	if (interest > 0) then
		outputChatBox("    Bankkamat: #00FF00Ft" .. exports.global:formatMoney(interest) .. " (0.4%)",255, 194, 14, true)
	end
	
	-- donator money (nonRP)
	if (donatormoney > 0) then
		outputChatBox("    Támogatói pénz: #00FF00Ft" .. exports.global:formatMoney(donatormoney), 255, 194, 14, true)
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 0) then
		outputChatBox("    Jövedelemadó " .. (incomeTax*100) .. "%: #FF0000Ft" .. exports.global:formatMoney(tax), 255, 194, 14, true)
	end
	
	if (vtax > 0) then
		outputChatBox("    Gépjármű adó: #FF0000Ft" .. exports.global:formatMoney(vtax), 255, 194, 14, true)
	end
	
	if (ptax > 0) then
		outputChatBox("    Ingatlan költségek: #FF0000Ft" .. exports.global:formatMoney(ptax), 255, 194, 14, true )
	end
	
	if (rent > 0) then
		outputChatBox("    Apartman bérlés: #FF0000Ft" .. exports.global:formatMoney(rent), 255, 194, 14, true)
	end
	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 0 then
		outputChatBox("  Bruttó jövedelem: 0",255, 194, 14, true)
	elseif (grossincome > 0) then
		outputChatBox("  Bruttó jövedelem: #00FF00Ft" .. exports.global:formatMoney(grossincome),255, 194, 14, true)
		outputChatBox("  Megjegyzés: A pénz elküldve a bankszámládra.", 255, 194, 14)
	else
		outputChatBox("  Bruttó jövedelem: #FF0000Ft" .. exports.global:formatMoney(grossincome), 255, 194, 14, true)
		outputChatBox("  Megjegyzés: Kifizetve a bankszámládról.", 255, 194, 14)
	end
	
	
	if (pay + tax == 0) then
		if not (faction) then
			outputChatBox("    Az önkormányzat nem tudja fizetni az állami juttatásokat.", 255, 0, 0)
		else
			outputChatBox("    A munkáltatód nem tudja megfizetni a béredet.", 255, 0, 0)
		end
	end
	
	if (rent == -1) then
		outputChatBox("    Kilakoltattak az apartmanodból, mert nem tudtad kifizetni.", 255, 0, 0)
	end
	
	outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	-- end of output payslip
	
	triggerEvent("updateWaves", getLocalPlayer())
end
addEvent("cPayDay", true)
addEventHandler("cPayDay", getRootElement(), cPayDay)