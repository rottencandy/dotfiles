-- Trim whitespace from strings
-- Source: PIL 20.4

local util = {}

function util.trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

return util

-- vim: et:sw=4:fdm=marker:textwidth=80
