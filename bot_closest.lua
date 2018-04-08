local bot_closest = {}

local function bot_closest.closest(bot)
	local allied_creeps = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
	
	local closest_creep
	
	local closest = 10000
	local creep_loc
	for k,au in pairs(allied_creeps) do
		local distance = ( GetUnitToUnitDistance(bot,au))
		if distance < closest then 
			closest = distance
			closest_creep = au
			creep_loc = au:GetLocation()
	end
	return closest,closest_creeps,creep_loc
end

return bot_closest
