-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- load fennel
local fennel = require('fennel')
fennel.path = fennel.path .. ';.config/awesome/?.fnl'
table.insert(package.loaders or package.searchers, fennel.searcher)
require('cfg')

-- vim: et:sw=4:fdm=marker:tw=80
