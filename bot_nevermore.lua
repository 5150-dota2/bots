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

  -- Moving to lane
  -- if DotaTime() < 0 then
  --   local midTower = GetTower(bot:GetTeam(), TOWER_MID_1)
  --   return
  -- else
  --   Act()
  -- end
end


-- function Act()
--   local loc = bot:GetLocation()
--   local m = {}
--   local a = {}
--
--   -- for k in pairs(moves) do
--   --   table.insert(m, k)
--   -- end
--
--   for k in pairs(attack) do
--     table.insert(a, k)
--   end
--   --
--   if not bot.lastActionTime then bot.lastActionTime = 0 end
--
--   if RealTime() - bot.lastActionTime > 0.2 then
--     bot.lastActionTime = RealTime()
--     attack[a[1]](bot)
--     -- moves[m[math.random(#m)]](bot)
--   end
-- end

-- example Act function that talk with machine learning server
function Act()
  -- if bot:GetTeam() == TEAM_DIRE then return end
  local loc = bot:GetLocation()
  if not bot.lastAction then bot.lastAction = 0 end
  if not bot.lastActionTime then bot.lastActionTime = 0 end
  if not bot.actionQueue then bot.actionQueue = {} end
  if not bot.lastReward then bot.lastReward = 0 end
  if not bot.lastHealth then bot.lastHealth = bot:GetHealth() end
  if bot.waitingRes == nil then bot.waitingRes = false end
  if not bot.frame then bot.frame = 0 end

  bot.frame = bot.frame + 1

  if #bot.actionQueue > 0 then
    bot.frame = 0
    local action = table.remove(bot.actionQueue, 1)
    moves[action](bot)
    bot.lastAction = action
    return
  end


  if not bot.waitingRes and bot.frame >= 7 then
    local velocity = bot:GetVelocity()
    local facing = bot:GetVelocity()
    local nearbyEnemyTowers = bot:GetNearbyTowers(700, true)
    local nearbyAlliedTowers = bot:GetNearbyTowers(700, false)
    local nearbyEnemyCreeps = bot:GetNearbyCreeps(700, true)
    local nearbyAlliedCreeps = bot:GetNearbyCreeps(700, false)
    bot.waitingRes = true
    local start = RealTime()
    request:Send({
      team = bot:GetTeam(),
      isAlive = bot:IsAlive(),
      heroX = loc.x,
      heroY = loc.y,
      heroVelX = velocity.x,
      heroVelY = velocity.y,
      heroFacing = bot:GetFacing(),
      heroAnimation = bot:GetAnimActivity(),
      health = bot:GetHealth(),
      numberOfNearbyEnemyTowers = #nearbyEnemyTowers,
      numberOfNearbyAlliedTowers = #nearbyAlliedTowers,
      numberOfNearbyEnemyCreeps = #nearbyEnemyCreeps,
      numberOfNearbyAlliedCreeps = #nearbyAlliedCreeps,
      dotaTime = DotaTime(),
      reward = bot.lastReward,
      frame = bot.frame,
    }, function(res)
      table.insert(bot.actionQueue, res.action)
      bot.waitingRes = false
    end)
    bot.frame = 0

    bot.lastReward = 0

    -- Punish when took damage
    if bot.lastHealth > bot:GetHealth() then
      bot.lastReward = bot.lastReward - 100
    end
    bot.lastHealth = bot:GetHealth()

    local distance_to_mid = GetUnitToLocationDistanceSqr(bot, Vector(-450, -450))
    bot.lastReward = bot.lastReward - distance_to_mid * 0.00001

    if #bot:GetNearbyLaneCreeps(500, true) > 0 then
      bot.lastReward = bot.lastReward + 100
    end
  end
end
