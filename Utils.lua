local utils = {}

function utils.attach(source, dest)
    for k, v in pairs(source) do
        dest[k] = v
    end
end

return utils
