ballNames={
	[2995]="Csíkos 1-es golyót",
	[2996]="Csíkos 2-es golyót",
	[2997]="Csíkos 3-as golyót",
	[2998]="Csíkos 4-es golyót",
	[2999]="Csíkos 5-ös golyót",
	[3000]="Csíkos 6-os golyót",
	[3001]="Csíkos 7-es golyót",

	[3002]="One solid", 

	[3003]="Fehér golyót",

	[3100]="Teli 2-es golyót",
	[3101]="Teli 3-as golyót",
	[3102]="Teli 4-es golyót",
	[3103]="Teli 5-ös golyót",
	[3104]="Teli 6-os golyót",
	[3105]="Teli 7-es golyót",
	[3106]="Fekete golyót",
}


function shuffle(t)
  local n = #t
 
  while n >= 2 do
    -- n is now the last pertinent index
    local k = math.random(n) -- 1 <= k <= n
    -- Quick swap
    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function findRotation(startX, startY, targetX, targetY)	-- Doomed-Space-Marine
	local t = -math.deg(math.atan2(targetX - startX, targetY - startY))
	
	if t < 0 then
		t = t + 360
	end
	
	return t
end
