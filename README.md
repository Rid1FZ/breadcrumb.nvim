# breadcrumb.nvim
This repository is a fork of [loctvl842/breadcrumb.nvim](https://github.com/loctvl842/breadcrumb.nvim)

## 📦 Installation

### Lazy.nvim

```lua
{
    "Rid1FZ/breadcrumb.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("breadcrumb").setup({})
    end
}
```

## ⚙️ Configuration

```lua
require("breadcrumb").setup({
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
	icons = {
		Namespace = "󰌗 ",
		Text = "󰉿 ",
		Method = "󰆧 ",
		Function = "󰊕 ",
		Constructor = " ",
		Field = " ",
		Variable = "󰀫 ",
		Class = "󰠱 ",
		Interface = " ",
		Module = " ",
		Property = "󰜢 ",
		Unit = "󰑭 ",
		Value = "󰎠 ",
		Enum = " ",
		Keyword = "󰌋 ",
		Snippet = " ",
		Color = "󰏘 ",
		File = "󰈚 ",
		Reference = "󰈇 ",
		Folder = "󰉋 ",
		EnumMember = " ",
		Constant = "󰏿 ",
		Struct = "󰙅 ",
		Event = " ",
		Operator = "󰆕 ",
		TypeParameter = "󰊄 ",
		Table = " ",
		Object = "󰅩 ",
		Tag = " ",
		Array = " ",
		Boolean = " ",
		Number = " ",
		Null = "󰟢 ",
		String = " ",
		Calendar = " ",
		Watch = "󰥔 ",
		Package = " ",
		Copilot = " ",
		Codeium = " ",
		TabNine = " ",
	},
	color_icons = true,
	separator = "",
	depth_limit = 0,
	depth_limit_indicator = "..",
	highlight_group = {
		component = "BreadcrumbText",
		separator = "BreadcrumbSeparator",
	},
})
```

To have **breadcrumb**, it must be attached to lsp server.

Example:

```lua
local breadcrumb = require("breadcrumb")

local on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        breadcrumb.attach(client, bufnr)
    end
end
```

## 🚀 Usage

- We can turn on `breadcrumb` by put this in the config file:

```lua
require("breadcrumb").init()
```

- Using method `get_breadcrumb()` combine with status line plugin for example `lualine`

```lua
local breadcrumb = function()
	local breadcrumb_status_ok, breadcrumb = pcall(require, "breadcrumb")
	if not breadcrumb_status_ok then
		return
	end
	return breadcrumb.get_breadcrumb()
end

local config = {
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { breadcrumb },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { breadcrumb },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
}

lualine.setup(config)
```

## Command

- `BreadcrumbEnable` command to enable `breadcrumb`
- `BreadcrumbDisable` command to disable `breadcrumb`
