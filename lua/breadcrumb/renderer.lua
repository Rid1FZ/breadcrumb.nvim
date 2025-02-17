local utils = require("breadcrumb.utils")

M = {}

local config = {
    icons = {
        ["Folder"] = "󰉋 ",
    },
    disabled_filetype = {
        "NeogitCommitMessage",
        "netrw",
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neo-tree",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "git",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "Jaq",
        "harpoon",
        "dap-repl",
        "dap-terminal",
        "dapui_console",
        "dapui_hover",
        "lab",
        "notify",
        "noice",
        "neotest-summary",
        "terminal",
        "mason",
        "",
    },
    separator = "",
    highlight_group = {
        inactive_winbar = "BreadcrumbInactiveWinbar",
        component = "BreadcrumbText",
        separator = "BreadcrumbSeparator",
        folder = "BreadcrumbIconsFolder",
    },
}

function M.setup(user_config)
    config = vim.tbl_deep_extend("force", config, user_config)
end

-- @return string containing filename
local function get_filename(inactive)
    local value = ""
    local inactive_hl_group = config.highlight_group.inactive_winbar
    local cur_filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")

    if not utils.isempty(cur_filename) then
        local file_icon, file_icon_color =
            require("nvim-web-devicons").get_icon_color(cur_filename, extension, { default = true })

        if utils.isempty(file_icon) then
            file_icon = ""
            file_icon_color = ""
        end

        local hl_group = ""
        if inactive then
            hl_group = inactive_hl_group
        else
            hl_group = "FileIconColor" .. extension
            vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
        end

        local hl_icon = "%#" .. hl_group .. "#" .. file_icon .. "%*"
        local hl_filename = "%#"
            .. (inactive and inactive_hl_group or config.highlight_group.component)
            .. "#"
            .. cur_filename
            .. "%*"

        value = value .. hl_icon .. " " .. hl_filename
    end

    return value
end

-- @return string containing path to file
local function get_filepath()
    local cur_filename = vim.fn.expand("%:t")
    if M.filename == cur_filename then
        return M.filepath_output
    end
    M.filename = cur_filename

    local value = " "
    local cwd = vim.fn.getcwd()
    local project_dir = vim.split(cwd, "/")
    local project_name = project_dir[#project_dir]
    local root = vim.fn.expand("%:h")

    project_name = string.gsub(project_name, "-", "%%-")
    local i, j = string.find(root, project_name)
    if not utils.isempty(i) then
        root = string.sub(root, i)
    end

    if not utils.isempty(root) and root ~= "." then
        local root_parts = utils.split(root, "/")
        for _, rp in ipairs(root_parts) do
            local hl_separator = "%#" .. config.highlight_group.separator .. "#" .. config.separator .. "%*"
            local hl_icon = "%#" .. config.highlight_group.folder .. "#" .. config.icons["Folder"] .. "%*"
            local hl_rp = "%#" .. config.highlight_group.component .. "#" .. rp .. "%*"
            value = value .. hl_icon .. hl_rp .. " " .. hl_separator .. " "
        end
    end

    value = value .. get_filename(false)
    M.filepath_output = value

    return value
end

-- @return navic value
local function get_navic()
    local status_ok, navic = pcall(require, "breadcrumb.navic")
    if not status_ok then
        return ""
    end

    local status_location_ok, navic_location = pcall(navic.get_location, {})
    if not status_location_ok then
        return ""
    end

    if not navic.is_available() or navic_location == "error" then
        return ""
    end
    if utils.isempty(navic_location) then
        return ""
    else
        local hl_separator = "%#" .. config.highlight_group.separator .. "#" .. config.separator .. "%*"
        return hl_separator .. " " .. navic_location
    end
end

-- @return string combine file path and navic value
function M.create_breadcrumb()
    local breadcrumb_output = get_filepath()

    local navic_added = false
    if not utils.isempty(breadcrumb_output) then
        local navic_value = get_navic()
        breadcrumb_output = breadcrumb_output .. " " .. navic_value
        if not utils.isempty(navic_value) then
            navic_added = true
        end
    end

    if not utils.isempty(breadcrumb_output) and utils.get_buf_option("mod") then
        local mod = "%#" .. config.highlight_group.component .. "#" .. "●" .. "%*"
        if navic_added then
            breadcrumb_output = breadcrumb_output .. " " .. mod
        else
            breadcrumb_output = breadcrumb_output .. mod
        end
    end
    return breadcrumb_output
end

-- @return string containing filename and icon
function M.create_inactive_breadcrumb()
    local breadcrumb_output = get_filename(true)
    return breadcrumb_output
end

function M.get_filepath()
    return get_filepath()
end

return M
