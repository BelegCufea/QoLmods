local moduleName = "Sticky Targeting"

local QoLmods = select(2, ...)
local Module = QoLmods:NewModule(moduleName, "AceEvent-3.0")

local function toggleSticky(_, event)
    SetCVar("deselectOnClick",event=="PLAYER_REGEN_DISABLED" and 0 or 1)
end

function Module:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_ENABLED", toggleSticky)
	self:RegisterEvent("PLAYER_REGEN_DISABLED", toggleSticky)
end

function Module:OnDisable()
	self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	self:UnregisterEvent("PLAYER_REGEN_DISABLED")
end

function Module:OnInitialize()
end

function Module:Info()
	return "Sets Blizzard's `Sticky Targeting` while you are in combat and turns it off as soon as you leave it."
end

