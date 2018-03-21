local function attack(bot)
  local enemy_creeps = GetUnitList(UNIT_LIST_ENEMY_CREEPS)
  local enemy_hero = GetUnitList(UNIT_LIST_ENEMY_HEROES)
  local e_unit = enemy_creeps[math.random(#enemy_creeps)]
  print(#enemy_creeps)
  bot:Action_MoveToUnit(e_unit)
  if e_unit:GetHealth() > (bot:GetAttackDamage()*2) then
    bot:Action_AttackUnit(e_unit, true)
  end

  for k,eu in pairs(enemy_creeps) do
    if eu:GetHealth() < bot:GetAttackDamage() then
      if GetUnitToUnitDistance(bot, eu) > bot:GetAttackRange() then
        bot:Action_MoveToUnit(eu)
      else
        bot:Action_AttackUnit(eu, true)
        break
      end
    end
  end
end

local last_hit = {attack = attack}

return last_hit
