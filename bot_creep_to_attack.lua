local bot_creep_to_attack = {}

function bot_creep_to_attack.getcreep(bot)
  local ecta
  local enemy_creeps = bot:GetNearbyLaneCreeps(500, true)
  local hits_table = {}
  for k,eu in pairs(enemy_creeps) do
    number_of_hits = (eu:GetHealth()/bot:GetAttackDamage())
    table.insert(hits_table, eu,  number_of_hits)
  end
  local least_hits = math.max(x, ...);
  for eu,k in ipairs(hits_table) do
    if(k < least_hits) then
      least_hits = k
      ecta = eu
    end
  end
  return ecta
end

return bot_creep_to_attack
