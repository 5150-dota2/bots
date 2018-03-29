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
  local loc = bot:GetLocation()
  print(bot:GetTeam())
  if not bot.lastAction then bot.lastAction = 0 end
  if not bot.lastActionTime then bot.lastActionTime = 0 end
  if not bot.actionQueue then bot.actionQueue = {} end
  if not bot.lastReward then bot.lastReward = 0 end
  if not bot.lastHealth then bot.lastHealth = bot:GetHealth() end
  if bot.waitingRes == nil then bot.waitingRes = false end

  if #bot.actionQueue > 0 then
    local action = table.remove(bot.actionQueue, 1)
    moves[action](bot)
    bot.lastAction = action
    return
  end

  if not bot.waitingRes then
    local velocity = bot:GetVelocity()
    local facing = bot:GetVelocity()
    print(bot:GetAnimActivity())
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
      health = bot:GetHealth(),
      reward = bot.lastReward
    }, function(res)
      table.insert(bot.actionQueue, res.action)
      bot.waitingRes = false
    end)

    bot.lastReward = 0

    -- Punish when took damage
    bot.lastReward = bot:GetHealth() - bot.lastHealth
    bot.lastHealth = bot:GetHealth()

    local distance_to_mid = GetUnitToLocationDistanceSqr(bot, Vector(-450, -450))
    bot.lastReward = bot.lastReward - distance_to_mid * 0.00001

    if #bot:GetNearbyLaneCreeps(500, true) > 0 then
      bot.lastReward = bot.lastReward + 0.3
    end
  end
end
