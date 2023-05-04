local moduleName = "Unlimited distance"

local QoLmods = select(2, ...)
local Module = QoLmods:NewModule(moduleName, "AceHook-3.0")

local C_Navigation = C_Navigation
local SuperTrackedFrame = SuperTrackedFrame

function Module:OnEnable()
    self:RawHook(
        SuperTrackedFrame,
        "GetTargetAlphaBaseValue",
        function(frame)
            if C_Navigation:GetDistance() > 999 then
                return 1
            else
                return self.hooks[SuperTrackedFrame]["GetTargetAlphaBaseValue"](frame)
            end
        end,
        true
    )

    if not SuperTrackedFrame.DistanceText.__UDSetText then
        SuperTrackedFrame.DistanceText.__UDSetText = SuperTrackedFrame.DistanceText.SetText
    end
    self:SecureHook(
        SuperTrackedFrame.DistanceText,
        "SetText",
        function(frame, text)
            frame:__UDSetText(BreakUpLargeNumbers(C_Navigation:GetDistance()))
        end)
end

function Module:OnDisable()
    if self:IsHooked(SuperTrackedFrame, "GetTargetAlphaBaseValue") then
        self:Unhook(SuperTrackedFrame, "GetTargetAlphaBaseValue")
    end
    if self:IsHooked(SuperTrackedFrame.DistanceText,"SetText") then
        self:Unhook(SuperTrackedFrame.DistanceText,"SetText")
    end
end

function Module:OnInitialize()
end

function Module:Info()
	return "Removes the 1000 yards limit on map pins. Also removes units and formats distance."
end
