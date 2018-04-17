local Log = require(GetScriptDirectory() .. "/log");
local moves = require(GetScriptDirectory() .. "/bot_moves")
local attack = require (GetScriptDirectory() .. "/bot_last_hit")
local request = require(GetScriptDirectory() .. "/request")
local utils = require(GetScriptDirectory() .. "/utils")

local bot = GetBot()

function Think()
  local location = bot:GetLocation()
  bot:ActionImmediate_Chat(string.format("Location: %f, %f", location.x, location.y), false)
  Act()
end



-- example Act function that talk with machine learning server
function Act()
  if bot:GetTeam() == TEAM_DIRE then return end
  if not bot:IsAlive() then return end

  local loc = bot:GetLocation()
  if not bot.lastAction then bot.lastAction = 0 end
  if not bot.actionQueue then bot.actionQueue = {} end
  if not bot.lastReward then bot.lastReward = 0 end
  if not bot.lastHealth then bot.lastHealth = bot:GetHealth() end
  if not bot.lastHits then bot.lastHits = 0 end
  if not bot.lastDeathCount then bot.lastDeathCount = GetHeroDeaths(bot:GetPlayerID()) end
  if bot.waitingRes == nil then bot.waitingRes = false end
  if not bot.frame then bot.frame = 0 end


  bot.frame = bot.frame + 1

  if #bot.actionQueue > 0 then
    bot.frame = 0
    local action = table.remove(bot.actionQueue, 1)
    if action == 9 then print(string.format("%s attack:", bot:GetTeam()), bot:GetAnimActivity()) end
    moves[action](bot)
    bot.lastAction = action
    return
  end


  if not bot.waitingRes and bot.frame >= 15 then
    local velocity = bot:GetVelocity()
    local facing = bot:GetVelocity()
    local nearbyEnemyTowers = bot:GetNearbyTowers(800, true)
    local nearbyAlliedTowers = bot:GetNearbyTowers(700, false)
    local nearbyEnemyCreeps = bot:GetNearbyCreeps(450, true)
    local nearbyAlliedCreeps = bot:GetNearbyCreeps(450, false)
    local nearbyNeutralCreeps = bot:GetNearbyNeutralCreeps(250)
    local nearbyEnemyHeroes = bot:GetNearbyHeroes(450, true, BOT_MODE_NONE)
    local attackingCreepCount = utils:GetNumberOfAttackingCreeps(bot, nearbyEnemyCreeps)
    local attackingTowerCount = utils:GetNumberOfAttackingTowers(bot, nearbyEnemyTowers)
    bot.waitingRes = true
    local start = RealTime()
    request:Send({
      team = bot:GetTeam(),
      heroX = loc.x,
      heroY = loc.y,
      heroVelX = velocity.x,
      heroVelY = velocity.y,
      heroFacing = bot:GetFacing(),
      heroAnimation = bot:GetAnimActivity(),
      heroAADmg = bot:GetAttackDamage(),
      heroAttackSpeed = bot:GetAttackSpeed(),
      numberOfNearbyEnemyHeroes = #nearbyEnemyHeroes,
      numberOfNearbyEnemyTowers = #nearbyEnemyTowers,
      numberOfNearbyEnemyCreeps = #nearbyEnemyCreeps,
      numberOfAttackingTowers = attackingTowerCount,
      numberOfAttackingCreeps = attackingCreepCount,
      numberOfNearbyAlliedTowers = #nearbyAlliedTowers,
      numberOfNearbyAlliedCreeps = #nearbyAlliedCreeps,
      numberOfNearbyNeutralCreeps = #nearbyNeutralCreeps,
      lowestEnemyCreepHealth = utils:GetLowestCreepHealth(bot, nearbyEnemyCreeps),
      reward = bot.lastReward,
    }, function(res)
      table.insert(bot.actionQueue, res.action)
      bot.waitingRes = false
    end)
    bot.frame = 0

    bot.lastReward = #nearbyAlliedTowers * 20 + #nearbyAlliedCreeps * 10

    -- Punish when took damage
    if attackingCreepCount > 0 or attackingTowerCount > 0 then
      bot.lastReward = bot.lastReward - ((attackingCreepCount * 70) + (attackingTowerCount * 200))
    end



    local desired = Vector(-1544/2, -1408/2)
    local cir = Vector(1544/2, 1408/2)
    local red = (bot:GetTeam() == TEAM_RADIANT) and 0 or 255
    local green = (bot:GetTeam() == TEAM_RADIANT) and 255 or 0

    -- Draw the desired location on the ground, green for Radiant, red for Dire
    DebugDrawCircle(desired, 20, red, green, 0)
    DebugDrawCircle(cir, 20, red, green, 0)

    local distance_to_mid = GetUnitToLocationDistanceSqr(bot, desired)
    bot.lastReward = bot.lastReward - distance_to_mid * 0.00001

    local animation = bot:GetAnimActivity()
    if animation == ACTIVITY_ATTACK or animation == ACTIVITY_ATTACK2 or animation == ACTIVITY_ATTACK_EVENT then
      bot.lastReward = bot.lastReward + 100
    end

    if animation == ACTIVITY_IDLE or animation == ACTIVITY_IDLE_RARE then
      bot.lastReward = bot.lastReward - 50
    end

    if bot:GetLastHits() > bot.lastHits then
      bot.lastReward = bot.lastReward + 500
      bot.lastHits = bot:GetLastHits()
    end

  end
end
