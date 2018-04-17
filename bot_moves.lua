local utils = require(GetScriptDirectory() .. "/utils")

local val = 500

local function DoNothing(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x, loc.y))
end

local function Stop(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x, loc.y))
end

local function Up(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x, loc.y + val))
end

local function Down(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x, loc.y - val))
end

local function Left(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x - val, loc.y))
end

local function Right(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x + val, loc.y))
end

local function UpLeft(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x - val, loc.y + val))
end

local function UpRight(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x + val, loc.y + val))
end

local function DownLeft(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x - val, loc.y - val))
end

local function DownRight(bot)
  local loc = bot:GetLocation()
  bot:Action_MoveDirectly(Vector(loc.x + val, loc.y - val))
end

local function Attack(bot)
  local enemyCreeps = bot:GetNearbyCreeps(650, true)
  if #enemyCreeps == 0 then return end

  local lowestHealth = 10000
  local toBeAttack = nil

  for i, creep in pairs(enemyCreeps) do
    if creep ~= nil then
      if creep:GetHealth() < lowestHealth then
        toBeAttack = creep
        lowestHealth = creep:GetHealth()
      end
    end
  end

  bot:Action_AttackUnit(toBeAttack, true)
end

-- local moves = {
--   Stop = Stop,
--   Up = Up,
--   Down = Down,
--   Left = Left,
--   Right = Right,
--   UpLeft = UpLeft,
--   UpRight = UpRight,
--   DownLeft = DownLeft,
--   DownRight = DownRight,
-- }

local moves = {
  Up,
  Down,
  Left,
  Right,
  UpLeft,
  UpRight,
  DownLeft,
  DownRight,
  Attack
}

return moves
