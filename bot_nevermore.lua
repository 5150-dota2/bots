local Log = require("bots/" .. "/log");
local moves = require("bots/" .. "/bot_moves")
local attack = require ("bots/" .. "/bot_last_hit")
local request = require("bots/" .. "/request")
local utils = require("bots/" .. "/utils")
local creep_to_attack_module = require("bots/" .. "bot_creep_to_attack")
local log_closest_creep = require("bots/" .. "bot_closest")
local bot = GetBot()
local enemy_hero = bot:GetNearbyHeroes(500, true, BOT_MODE_NONE)[1]
function Think()

  local location = bot:GetLocation()
  bot:ActionImmediate_Chat(string.format("Location: %f, %f", location.x, location.y), false)
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
function Act()
  local loc = bot:GetLocation()
  local eloc = enemy_hero:GetLocation()
  local creep_to_attack = creep_to_attack_module.getcreep(bot)
  local alliedTower = GetTower(bot:GetTeam(), TOWER_MID_1)
  local enemyTower = GetTower(enemy_hero:GetTeam(), TOWER_MID_1)
  local lastHealth = 0
  print(lastHealth)
  if not bot.lastAction     then bot.lastAction = 0  end
  if not bot.lastActionTime    then bot.lastActionTime = 0  end
  if not bot.actionQueue    then bot.actionQueue = {}  end
  if not bot.lastReward then bot.lastReward = 0  end
  if lastHealth == nil then lastHealth = bot:GetMaxHealth()  end
  if not bot.lastEnemyHealth then bot.lastEnemyHealth = enemy_hero:GetHealth()   end
  if bot.waitingRes == nil then bot.waitingRes = false  end
  -- for last hits
  if not bot.lastHit     then bot.lastHit = bot:GetLastHits()  end
  if not bot.lastAlliedTowerHealth     then bot.lastAlliedTowerHealth = alliedTower:GetHealth()   end
  if not bot.lastEnemyTowerHealth     then bot.lastEnemyTowerHealth = enemyTower:GetHealth()  end
  -- for xp rewards
  if not bot.lastxp     then bot.lastxp = bot:GetXPNeededToLevel()  end
  if not lastlevel     then lastlevel = bot:GetLevel()  end
  --for creep blocking
  local closest, closest_creeps,creep_loc = log_closest_creep.getclosest(bot)
  if not bot.lastclosest_creeps      then bot.lastclosest_creeps = closest_creeps:GetLocation()  end
  local enemyIsAlive = enemy_hero:IsAlive()
  local enemyheroX = eloc.x
  local enemyheroY = eloc.y
  local enemyheroVelX = evelo.x
  local enemyheroVelY = evelo.y
  local enemyheroFacing = enemy_hero:GetFacing()
  local enemyheroAnimation = enemy_hero:GetAnimActivity()
  local creephealth = creep_to_attack:GetHealth()
  local enemyhealth = enemy_hero:GetHealth()
  if  enemyIsAlive == nil     then enemyIsAlive = 0  end
  if  enemyheroX== nil     then enemyheroX = 0  end
  if  enemyheroY== nil     then enemyheroY = 0  end
  if  enemyheroVelX== nil      then enemyheroVelX = 0  end
  if  enemyheroVelY== nil    then enemyheroVelY = 0  end
  if  enemyheroFacing== nil    then enemyheroFacing = closest_creeps:GetLocation()  end
  if  enemyheroAnimation== nil    then enemyheroAnimation = closest_creeps:GetLocation()  end
  if  creephealth== nil    then creephealth = closest_creeps:GetLocation()  end
  if  enemyhealth== nil    then enemyhealth = closest_creeps:GetLocation()  end
  if #bot.actionQueue > 0 then
    local action = table.remove(bot.actionQueue, 1)
    moves[action](bot)
    bot.lastAction = action
    return
  end
  if not bot.waitingRes then
    local velocity = bot:GetVelocity()
    local evelo = enemy_hero:GetVelocity()
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
      enemyIsAlive = 0,
      enemyheroX = 0,
      enemyheroY = 0,
      enemyheroVelX = 0,
      enemyheroVelY = 0,
      enemyheroFacing = 0,
      enemyheroAnimation = 0,
      creephealth = 0,
      health = bot:GetHealth(),
      enemyhealth = 0,
      reward = bot.lastReward
    },
    function(res)
      table.insert(bot.actionQueue, res.action)
      bot.waitingRes = false
    end)
    bot.lastReward = 0

    --reward for creepblocking
    local distance = (GetUnitToLocationDistance(closest_creeps,creep_loc))
    if distance <20 then bot.lastReward = bot.lastReward +5
      elseif distance<40 then bot.lastReward = bot.lastReward +2
        elseif distance<60 then bot.lastReward = bot.lastReward +1
        end
      end
    end
    -- Punish when took damage

    bot.lastReward = (bot:GetHealth() - bot.lastHealth)*7
    bot.lastHealth = bot:GetHealth()
    -- reward for leveling up
    local level = bot:GetLevel()
    if level >lastlevel then bot.lastReward = bot.lastReward + 10
      bot.lastxp = bot:GetXPNeededToLevel() end

    --reward for staying near xp rich areas
    local xp = bot:GetXPNeededToLevel()
    local xp_gained = bot.lastxp - xp
    bot.lastReward = bot.lastReward + xp_gained*2

    -- Punish when allied tower takes damage
    bot.lastReward = (alliedTower:GetHealth() - bot.lastAlliedTowerHealth)*5
    bot.lastAlliedTowerHealth = alliedTower:GetHealth()

    -- Give reward on last hit
    bot.lastReward = (bot.GetLastHits() - bot.lastHit)*5
    bot.lastHit = bot:GetLastHits()

    -- Reward for attacking the enemy hero
    bot.Reward = (bot.lastEnemyHealth - enemy_hero:GetHealth())*2
    bot.lastEnemyHealth = enemy_hero:GetHealth()

    -- Reward for attacking enemy TOWER
    bot.Reward = (bot.lastEnemyTowerHealth - enemyTower:GetHealth())*5
    bot.lastEnemyTowerHealth = enemyTower:GetHealth()

    local distance_to_mid = GetUnitToLocationDistanceSqr(bot, Vector(-450, -450))
    bot.lastReward = bot.lastReward - distance_to_mid * 0.001

    if #bot:GetNearbyLaneCreeps(500, true) > 0 then
      bot.lastReward = bot.lastReward + 10
    end
