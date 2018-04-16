local bot_creep_to_attack = {}

function bot_creep_to_attack.getcreep(bot)
  local ecta = nil
  local enemy_creeps = bot:GetNearbyCreeps(1599, true)
  if #enemy_creeps == 0 then return end
  local leasthealth = 99999
  for k,eu in pairs(enemy_creeps) do
    if eu ~= nil then
      if eu:GetHealth() < leasthealth then
        ecta = eu
        leasthealth = eu:GetHealth()
      end
    end
  end
  -- print("ecta-------------",ecta:GetUnitName())
  return ecta
end

return bot_creep_to_attack
