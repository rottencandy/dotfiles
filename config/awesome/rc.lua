-- load fennel
local fennel = require('fennel')
fennel.path = fennel.path .. ';.config/awesome/?.fnl'
table.insert(package.loaders or package.searchers, fennel.searcher)
require('cfg')

-- vim: et:sw=4:fdm=marker:tw=80
