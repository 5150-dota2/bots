

local function getclosest(bot)
	local allied_creeps
	if GetUnitList(UNIT_LIST_ALLIED_CREEPS) == nil then
    allied_creeps = nil
		dictionary["cc"]=-1
		dictionary["cl"]=-1
  else
    allied_creeps = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
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
		end
		local dictionary = {}
		dictionary["cc"] = closest_creep
		dictionary["cl"] = creep_loc
  end
	return dictionary
end
local bot_closest = {getclosest = getclosest}
return bot_closest
