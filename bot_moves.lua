local val = 250

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

local function normal_attack_creep(bot)
  local nevermore_module = require("bot_creep_to_attack")
  local creep_to_attack = nevermore_module.getcreep(bot)
  bot:Action_AttackUnit(creep_to_attack, true)
end

local function raze_200(bot)
  local nevermore_module = require("bot_creep_to_attack")
  local creep_to_attack = nevermore_module.getcreep(bot)
  bot:Action_UseAbilityOnLocation(nevermore_shadowraze1, creep_to_attack:GetLocation())
end

local function raze_450(bot)
  local nevermore_module = require("bot_creep_to_attack")
  local creep_to_attack = nevermore_module.getcreep(bot)
  bot:Action_UseAbilityOnLocation(nevermore_shadowraze2, creep_to_attack:GetLocation())
end

local function raze_700(bot)
  local nevermore_module = require("bot_creep_to_attack")
  local creep_to_attack = nevermore_module.getcreep(bot)
  bot:Action_UseAbilityOnLocation(nevermore_shadowraze3, creep_to_attack:GetLocation())
end

local function normal_attack_bot(bot)
  bot:Action_AttackUnit(bot:GetNearbyHeroes(500, true, BOT_MODE_NONE)[1], false)
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
  normal_attack_creep,
  raze_200,
  raze_450,
  raze_700,
  normal_attack_bot,
}

return moves
