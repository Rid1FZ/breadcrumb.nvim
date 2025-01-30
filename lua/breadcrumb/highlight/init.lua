M = {}

local skeleton = require("breadcrumb.highlight.group")

local function highlight(group, properties)
    local link = properties.link
    if link ~= nil then
        local cmd = "hi! link " .. group .. " " .. link
        vim.api.nvim_command(cmd)
    else
        local bg = properties.bg == nil and "" or "guibg=" .. properties.bg
        local fg = properties.fg == nil and "" or "guifg=" .. properties.fg
        local style = properties.style == nil and "" or "gui=" .. properties.style

        local cmd = table.concat({
            "highlight",
            group,
            bg,
            fg,
            style,
        }, " ")

        vim.api.nvim_command(cmd)
    end
end

function M.initialise()
    for group, properties in pairs(skeleton) do
        highlight(group, properties)
    end
end

return M
