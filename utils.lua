local utils = {}

function utils:Print(data)
  for k, v in pairs(data) do
    print(k, v)
  end
end

return utils;
