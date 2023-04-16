local moduleName = "Unlimited distance"

local QoLmods = select(2, ...)
local Module = QoLmods:NewModule(moduleName, "AceEvent-3.0")

local C_Navigation = C_Navigation
local SuperTrackedFrame = SuperTrackedFrame

local UD_OrginalGetTargetAlphaBaseValue
local UD_OriginalUpdateDistanceText

local function UD_GetTargetAlphaBaseValue(frame)
    if C_Navigation.GetDistance() > 999 then
        return 1
    else
        return UD_OrginalGetTargetAlphaBaseValue(frame)
    end
end

local function UD_UpdateDistanceText()
    if not SuperTrackedFrame.isClamped then
        local distance = C_Navigation.GetDistance()
        SuperTrackedFrame.DistanceText:SetText(BreakUpLargeNumbers(Round(distance)) .. " yds")
    end
    SuperTrackedFrame.DistanceText:SetShown(not SuperTrackedFrame.isClamped)
end

function Module:OnEnable()
    UD_OrginalGetTargetAlphaBaseValue = SuperTrackedFrame.GetTargetAlphaBaseValue
    UD_OriginalUpdateDistanceText = SuperTrackedFrame.UpdateDistanceText
    SuperTrackedFrame.GetTargetAlphaBaseValue = UD_GetTargetAlphaBaseValue
    SuperTrackedFrame.UpdateDistanceText = UD_UpdateDistanceText
end

function Module:OnDisable()
    if UD_OrginalGetTargetAlphaBaseValue then
        SuperTrackedFrame.GetTargetAlphaBaseValue = UD_OrginalGetTargetAlphaBaseValue
        UD_OrginalGetTargetAlphaBaseValue = nil
    end
    if UD_OriginalUpdateDistanceText then
        SuperTrackedFrame.UpdateDistanceText = UD_OriginalUpdateDistanceText
        UD_OriginalUpdateDistanceText = nil
    end
end

function Module:OnInitialize()
end

function Module:Info()
	return "Removes the 1000 yards limit put on map pins."
end
