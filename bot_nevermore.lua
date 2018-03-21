local Log = require(GetScriptDirectory() .. "/log");
local moves = require(GetScriptDirectory() .. "/bot_moves")
local attack = require (GetScriptDirectory() .. "/bot_last_hit")
local bot = GetBot()

function Think()
  local location = bot:GetLocation()
  bot:ActionImmediate_Chat(string.format("Location: %f, %f", location.x, location.y), false)

  -- Moving to lane
  if DotaTime() < 0 then
    local midTower = GetTower(bot:GetTeam(), TOWER_MID_1)
    bot:Action_MoveToLocation(midTower:GetLocation())
    return
  else
    Act()
  end
end

time = nil

function Act()
  local loc = bot:GetLocation()
  local m = {}
  local a = {}

  -- for k in pairs(moves) do
  --   table.insert(m, k)
  -- end

  for k in pairs(attack) do
    table.insert(a, k)
  end
  --
  if not bot.lastActionTime then bot.lastActionTime = 0 end

  -- -- Randomly pick a move
  if RealTime() - bot.lastActionTime > 0.2 then
    bot.lastActionTime = RealTime()
    attack[a[1]](bot)
    -- moves[m[math.random(#m)]](bot)
  end
end
