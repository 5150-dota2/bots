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
}

return moves
