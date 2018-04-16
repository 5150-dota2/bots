local utils = {}

function utils:Print(data)
  for k, v in pairs(data) do
    print(k, v)
  end
end

function utils:GetLowestCreepHealth(bot, enemyCreeps)
  if #enemyCreeps == 0 then return 0 end

  local lowestHealth = 100000

  for i, creep in pairs(enemyCreeps) do
    if creep ~= nil then
      if creep:GetHealth() < lowestHealth then
        lowestHealth = creep:GetHealth()
      end
    end
  end

  return lowestHealth
end

function utils:GetNumberOfAttackingCreeps(bot, enemyCreeps)
  local enemyCreeps = bot:GetNearbyCreeps(800, true)

  local num = 0

  for i, creep in pairs(enemyCreeps) do
    if creep ~= nil then
      if creep:GetAttackTarget() == bot then
        num = num + 1
      end
    end
  end

  return num
end

function utils:GetNumberOfAttackingTowers(bot, enemyTowers)
  local num = 0

  for i, tower in pairs(enemyTowers) do
    if tower ~= nil then
      if tower:GetAttackTarget() == bot then
        num = num + 1
      end
    end
  end

  return num
end


return utils;
