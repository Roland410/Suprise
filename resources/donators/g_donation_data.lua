-- Chooseable phone numbers
function checkValidNumber(number)
	if type(number) ~= "number" then
		return false, "Hibás szám"
	end
	
	if number ~= math.ceil(number) then
		return false, "Hibás szám"
	end
	
	if number < 100000 then
		return false, "A szám túl rövid"
	end
	
	if number > 999999999 then
		return false, "A szám túl hosszú"
	end
	
	-- enforce at least two different digits
	local str = tostring(number)
	local first = str:sub(1,1)
	for i = 2, #str do
		if str:sub(i, i) ~= first then
			return true
		end
	end
	return false, "Legalább két különböző számra van szükség."
end
