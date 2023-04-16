local ADDON_NAME = ...;
local QoLmods = LibStub("AceAddon-3.0"):NewAddon(select(2, ...), ADDON_NAME, "AceConsole-3.0")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Const = QoLmods.CONST
local Debug = QoLmods.DEBUG

QoLmods.defaults = {
    profile = {
        enabled = true,
        debug = false,
        modules = {},
    },
}

QoLmods.options = {
    type = "group",
    name = Const.METADATA.NAME,
    get = function(info)
        return QoLmods.db.profile[info[#info]]
    end,
    set = function(info, value)
        QoLmods.db.profile[info[#info]] = value;
    end,
    childGroups = "tab",
    args = {
        enabled = {
			type = "toggle",
			name = "Enabled",
			width = "full",
            order = 1,
            hidden = true,
        },
        debug = {
			type = "toggle",
			name = "Debug",
			width = "full",
            order = 2,
            hidden = true,
        },
        modules = {
            type = "group",
            name = "Modules",
            order = 9,
            args = {},
        }
    },
}

function QoLmods:OnEnable()
	for k, v in self:IterateModules() do
        local m = {
			type = "toggle",
			name = "|cnNORMAL_FONT_COLOR:" .. k .. "|r",
			width = "full",
			desc = v.Info and v:Info() or k,
			order = 10,
            descStyle = "inline",
			get = function() return self.db.profile.modules[k:gsub(" ", "_")] end,
			set = function(_, value)
				self.db.profile.modules[k:gsub(" ", "_")] = value
				if value then
					self:EnableModule(k)
				else
					self:DisableModule(k)
				end
			end
		}
        self.options.args.modules.args[k:gsub(" ", "_")] = m
        if self.db.profile.modules[k:gsub(" ", "_")] then v:Enable() else v:Disable() end
    end

    self.options.args.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
    self.options.args.Profiles.order = 80
    AceConfig:RegisterOptionsTable(Const.METADATA.NAME, self.options)
    AceConfigDialog:AddToBlizOptions(Const.METADATA.NAME)
end

function QoLmods:OnDisable()
	for _, v in self:IterateModules() do
		v:Disable()
	end
end

function QoLmods:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New(ADDON_NAME .. "DB", self.defaults, true)
end