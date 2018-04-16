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
  -- local nevermore_module = require("bots/" .. "bot_creep_to_attack")
  -- local creep_to_attack = nevermore_module.getcreep(bot)

  local ecta = nil
  local enemy_creeps = bot:GetNearbyCreeps(1599, true)
  if #enemy_creeps == 0 then return end
  local leasthealth = 99999
  for k,eu in pairs(enemy_creeps) do
    if eu ~= nil then
      if eu:GetHealth() < leasthealth then
        ecta = eu
        leasthealth = eu:GetHealth()
      end
    end
  end
  print("ecta-------------",ecta:GetUnitName())

  print("ahiya aavi ne gayu")
  print("normal attack**********************",ecta:GetUnitName())
  if ecta == nil then return end
  bot:Action_AttackUnit(ecta, false)
end

local function raze_200(bot)
  local ecta = nil
  local enemy_creeps = bot:GetNearbyCreeps(1599, true)
  if #enemy_creeps == 0 then return end
  local leasthealth = 99999
  for k,eu in pairs(enemy_creeps) do
    if eu ~= nil then
      if eu:GetHealth() < leasthealth then
        ecta = eu
        leasthealth = eu:GetHealth()
      end
    end
  end
  print("ecta-------------",ecta:GetUnitName())

  print("ahiya aavi ne gayu------200----")
  print("raze200**********************",ecta:GetUnitName())
  if ecta == nil then return end
  bot:Action_UseAbilityOnLocation("nevermore_shadowraze1", ecta:GetLocation())
end

local function raze_450(bot)
  local ecta = nil
  local enemy_creeps = bot:GetNearbyCreeps(1599, true)
  if #enemy_creeps == 0 then return end
  local leasthealth = 99999
  for k,eu in pairs(enemy_creeps) do
    if eu ~= nil then
      if eu:GetHealth() < leasthealth then
        ecta = eu
        leasthealth = eu:GetHealth()
      end
    end
  end
  print("ecta-------------",ecta:GetUnitName())

  print("ahiya aavi ne gayu------450----")
  print("raze450**********************",ecta:GetUnitName())
  if ecta == nil then return end
  bot:Action_UseAbilityOnLocation("nevermore_shadowraze2", ecta:GetLocation())
end

local function raze_700(bot)
  local ecta = nil
  local enemy_creeps = bot:GetNearbyCreeps(1599, true)
  if #enemy_creeps == 0 then return end
  local leasthealth = 99999
  for k,eu in pairs(enemy_creeps) do
    if eu ~= nil then
      if eu:GetHealth() < leasthealth then
        ecta = eu
        leasthealth = eu:GetHealth()
      end
    end
  end
  print("ecta-------------",ecta:GetUnitName())

  print("ahiya aavi ne gayu------700----")
  print("raze700**********************",ecta:GetUnitName())
  if ecta == nil then return end
  bot:Action_UseAbilityOnLocation("nevermore_shadowraze3", ecta:GetLocation())
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
