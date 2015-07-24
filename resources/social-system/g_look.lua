local function checkLength( value )
	return value and #value >= 0 and #value <= 90
end

editables = {
	{ name = "Bőrszin", index = "weight", verify = function( v ) return tonumber( v ) and tonumber( v ) >= 40 and tonumber( v ) <= 140 end },
	{ name = "Hajszín", index = 1, verify = checkLength },
	{ name = "Hajstilus", index = 2, verify = checkLength },
	{ name = "arcvonásai", index = 3, verify = checkLength },
	{ name = "Fizikai tulajdonság", index = 4, verify = checkLength },
	{ name = "Leírás", index = 5, verify = checkLength },
	{ name = "Kiegészítők", index = 6, verify = checkLength }
}