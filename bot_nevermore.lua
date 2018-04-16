local Log = require("bots/" .. "/log");
local moves = require("bots/" .. "/bot_moves")
local attack = require ("bots/" .. "/bot_last_hit")
local request = require("bots/" .. "/request")
local utils = require("bots/" .. "/utils")
local creep_to_attack_module = require("bots/" .. "bot_creep_to_attack")
-- local log_closest_creep = require("bots/" .. "bot_closest")
local bot = GetBot()


function Think()
bot:ActionImmediate_LevelAbility("nevermore_necromastery")
bot:ActionImmediate_LevelAbility("nevermore_shadowraze1")
bot:ActionImmediate_LevelAbility("nevermore_dark_lord")
bot:ActionImmediate_LevelAbility("nevermore_requiem")
  local location = bot:GetLocation()
  bot:ActionImmediate_Chat(string.format("Location: %f, %f", location.x, location.y), false)
  -- local raze = bot:GetAbilityByName()

  -- elseif bot:GetLevel() == 9 then ActionImmediate_LevelAbility(nevermore_dark_lord)
  -- elseif bot:GetLevel() == 10 then ActionImmediate_LevelAbility(special_bonus_movement_speed_15)
  -- elseif bot:GetLevel() == 11 then ActionImmediate_LevelAbility(nevermore_dark_lord)
  -- elseif bot:GetLevel() == 12 then ActionImmediate_LevelAbility(nevermore_dark_lord)
  -- elseif bot:GetLevel() == 13 then ActionImmediate_LevelAbility(nevermore_dark_lord)
  -- elseif bot:GetLevel() == 14 then ActionImmediate_LevelAbility(nevermore_requiem)
  -- elseif bot:GetLevel() == 15 then ActionImmediate_LevelAbility(special_bonus_spell_amplify_6)
  -- elseif bot:GetLevel() == 16 then ActionImmediate_LevelAbility(nevermore_requiem)
  -- elseif bot:GetLevel() == 18 then ActionImmediate_LevelAbility(nevermore_requiem)
  -- elseif bot:GetLevel() == 20 then ActionImmediate_LevelAbility(nevermore_necromastery)
  -- elseif bot:GetLevel() == 21 then ActionImmediate_LevelAbility(nevermore_necromastery)
  -- elseif bot:GetLevel() == 22 then ActionImmediate_LevelAbility(nevermore_necromastery)
  -- elseif bot:GetLevel() == 23 then ActionImmediate_LevelAbility(nevermore_necromastery)
  -- elseif bot:GetLevel() == 24 then ActionImmediate_LevelAbility(nevermore_necromastery)
  -- elseif bot:GetLevel() == 25 then ActionImmediate_LevelAbility(nevermore_necromastery)


  Act()

  -- Moving to lane
  -- if DotaTime() < 0 then
  --   local midTower = GetTower(bot:GetTeam(), TOWER_MID_1)
  --   return
  -- else
  --   Act()
  -- end
end
-- example Act function that talk with machine learning server

local function getclosest(bot)
  local dictionary = {}
	local allied_creeps = GetUnitList(UNIT_LIST_ALLIED_CREEPS)
	if allied_creeps == nil then
    allied_creeps = nil
		dictionary["cc"] = nil
		dictionary["cl"] = nil
  else

		local closest_creep

		local closest = 10000
		local creep_loc
		for k,au in pairs(allied_creeps) do
      -- print(allied_creeps)
			local distance = (GetUnitToUnitDistance(bot,au))
			if distance < closest then
				closest = distance
				closest_creep = au
				creep_loc = au:GetLocation()
			end
		end
		dictionary["cc"] = closest_creep
		dictionary["cl"] = creep_loc
  end
	return dictionary
end

function Act()
  local loc = bot:GetLocation()

  local enemy_hero
  if bot:GetNearbyHeroes(500, true, BOT_MODE_NONE) == nil then
    enemy_hero = nil
  else
    enemy_hero = bot:GetNearbyHeroes(500, true, BOT_MODE_NONE)[1]
  end

  local eloc, enemyIsAlive, evelo, enemyheroFacing, enemyheroAnimation, enemyhealth
  local enemyheroX, enemyheroY, enemyheroVelX, enemyheroVelY

  if enemy_hero == nil then
    eloc = -1
    enemyIsAlive = -1
    evelo = -1
    enemyheroFacing = -1
    enemyheroAnimation = -1
    enemyhealth = -1
    enemyheroX = -1
    enemyheroY = -1
    enemyheroVelX = -1
    enemyheroVelY = -1
  else
    eloc = enemy_hero:GetLocation()
    enemyIsAlive = enemy_hero:IsAlive()
    evelo = enemy_hero:GetVelocity()
    enemyheroFacing = enemy_hero:GetFacing()
    enemyheroAnimation = enemy_hero:GetAnimActivity()
    enemyhealth = enemy_hero:GetHealth()
    enemyheroX = eloc.x
    enemyheroY = eloc.y
    enemyheroVelX = evelo.x
    enemyheroVelY = evelo.y
  end

  local enemyTeam
  if bot:GetTeam() == 2 then
    enemyTeam = 3
  elseif bot:GetTeam() == 3 then
    enemyTeam = 2
  end

  local creep_to_attack = creep_to_attack_module.getcreep(bot)
  local alliedTower = GetTower(bot:GetTeam(), TOWER_MID_1)
  local enemyTower = GetTower(enemyTeam, TOWER_MID_1)


  if not bot.lastAction then bot.lastAction = 0  end
  if not bot.lastActionTime then bot.lastActionTime = 0  end
  if not bot.actionQueue then bot.actionQueue = {}  end
  if not bot.lastReward then bot.lastReward = 0  end
  if bot.lastHealth == nil then bot.lastHealth = bot:GetHealth()  end
  if not bot.lastEnemyHealth then bot.lastEnemyHealth = enemyhealth   end
  if bot.waitingRes == nil then bot.waitingRes = false  end
  -- for last hits
  if not bot.lastHit then bot.lastHit = bot:GetLastHits()  end
  if not bot.lastAlliedTowerHealth then bot.lastAlliedTowerHealth = alliedTower:GetHealth()   end
  if not bot.lastEnemyTowerHealth then bot.lastEnemyTowerHealth = enemyTower:GetHealth()  end
  -- for xp rewards
  if not bot.lastxp then bot.lastxp = bot:GetXPNeededToLevel()  end
  if not bot.lastlevel then bot.lastlevel = bot:GetLevel()  end
  --for creep blocking
  local diction = getclosest(bot)
  local cc = diction["cc"]
  local cl = diction["cl"]

  if cc == nil then
    bot.lastclosest_creeps = -1
  else
    bot.lastclosest_creeps = cc:GetLocation()
  end


  local creephealth
  if creep_to_attack == nil then
    creephealth = -1
  else
    creephealth = creep_to_attack:GetHealth()
  end


  -- if  enemyIsAlive == nil     then enemyIsAlive = 0  end
  -- if  enemyheroX== nil     then enemyheroX = 0  end
  -- if  enemyheroY== nil     then enemyheroY = 0  end
  -- if  enemyheroVelX== nil      then enemyheroVelX = 0  end
  -- if  enemyheroVelY== nil    then enemyheroVelY = 0  end
  -- if  enemyheroFacing== nil    then enemyheroFacing = closest_creeps:GetLocation()  end
  -- if  enemyheroAnimation== nil    then enemyheroAnimation = closest_creeps:GetLocation()  end
  if  creephealth == nil then creephealth = creep_to_attack:GetHealth() end
  -- if  enemyhealth== nil    then enemyhealth = closest_creeps:GetLocation()  end
  if #bot.actionQueue > 0 then
    local action = table.remove(bot.actionQueue, 1)
    moves[action](bot)
    bot.lastAction = action
    return
  end
  if not bot.waitingRes then
    local velocity = bot:GetVelocity()
    bot.waitingRes = true
    request:Send({
      team = bot:GetTeam(),
      isAlive = bot:IsAlive(),
      heroX = loc.x,
      heroY = loc.y,
      heroVelX = velocity.x,
      heroVelY = velocity.y,
      heroFacing = bot:GetFacing(),
      heroAnimation = bot:GetAnimActivity(),
      enemyIsAlive = enemyIsAlive,
      enemyheroX = enemyheroX,
      enemyheroY = enemyheroY,
      enemyheroVelX = enemyheroVelX,
      enemyheroVelY = enemyheroVelY,
      enemyheroFacing = enemyheroFacing,
      enemyheroAnimation = enemyheroAnimation,
      creephealth = creephealth,
      health = bot:GetHealth(),
      enemyhealth = enemyhealth,
      reward = bot.lastReward
    },
    function(res)
      table.insert(bot.actionQueue, res.action)
      bot.waitingRes = false
    end)
    bot.lastReward = 0

    --reward for creepblocking
    local distance = (GetUnitToLocationDistance(cc,cl))
    if distance <20 then
      bot.lastReward = bot.lastReward +5
    elseif distance<40 then
      bot.lastReward = bot.lastReward +2
    elseif distance<60 then
      bot.lastReward = bot.lastReward +1
    end
    -- Punish when took damage

    bot.lastReward = (bot:GetHealth() - bot.lastHealth)*7
    bot.lastHealth = bot:GetHealth()
    -- reward for leveling up
    local level = bot:GetLevel()
    if level > bot.lastlevel then bot.lastReward = bot.lastReward + 10
      bot.lastxp = bot:GetXPNeededToLevel()

      if bot:GetLevel() == 2 then ActionImmediate_LevelAbility("nevermore_shadowraze1") end
      if bot:GetLevel() == 3 then ActionImmediate_LevelAbility("nevermore_shadowraze1") end
      if bot:GetLevel() == 4 then ActionImmediate_LevelAbility("nevermore_necromastery") end
      if bot:GetLevel() == 5 then ActionImmediate_LevelAbility("nevermore_shadowraze1") end
      if bot:GetLevel() == 6 then ActionImmediate_LevelAbility("nevermore_necromastery") end
      if bot:GetLevel() == 7 then ActionImmediate_LevelAbility("nevermore_shadowraze1") end
      if bot:GetLevel() == 8 then ActionImmediate_LevelAbility("nevermore_necromastery")
      end
    end

    --reward for staying near xp rich areas
    local xp = bot:GetXPNeededToLevel()
    local xp_gained = bot.lastxp - xp
    bot.lastReward = bot.lastReward + xp_gained*2

    -- Punish when allied tower takes damage
    bot.lastReward = (alliedTower:GetHealth() - bot.lastAlliedTowerHealth)*5
    bot.lastAlliedTowerHealth = alliedTower:GetHealth()

    -- Give reward on last hit
    bot.lastReward = (bot:GetLastHits() - bot.lastHit)*100
    bot.lastHit = bot:GetLastHits()

    -- Reward for attacking the enemy hero
    bot.lastReward = (bot.lastEnemyHealth - enemyhealth)*2
    bot.lastEnemyHealth = enemyhealth

    -- Reward for attacking enemy TOWER
    bot.lastReward = (bot.lastEnemyTowerHealth - enemyTower:GetHealth())*5
    bot.lastEnemyTowerHealth = enemyTower:GetHealth()

    local distance_to_mid = GetUnitToLocationDistanceSqr(bot, Vector(-450, -450))
    bot.lastReward = bot.lastReward - distance_to_mid * 0.001

    if #bot:GetNearbyLaneCreeps(500, true) > 0 then
      bot.lastReward = bot.lastReward + 10
    end
  end
end
