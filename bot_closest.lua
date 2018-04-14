local bot_closest = {}

local function getclosest(bot)
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
	-- local dictionary = {}
	-- dictionary["cc"]=closest_creep
	return closest_creep--,creep_loc
end
end

--return bot_closest
