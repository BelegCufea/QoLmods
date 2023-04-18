local moduleName = "Time to Arrive"

local QoLmods = select(2, ...)
local Module = QoLmods:NewModule(moduleName, "AceEvent-3.0")

local _G = _G
local CreateFrame = _G.CreateFrame
local UIParent = _G.UIParent
local IsInInstance = _G.IsInInstance
local C_Map = _G.C_Map
local C_SuperTrack = _G.C_SuperTrack
local GetUnitSpeed = _G.GetUnitSpeed
local C_Navigation = _G.C_Navigation
local math = _G.math
local string = _G.string

local TimeToArrive
local elapsed

local function setTime(distance, speed)
    if speed and speed > 0 then
        local eta = math.abs(distance / speed)
        local minutes = math.floor(eta / 60)
        local seconds = math.floor(eta % 60)
        local tta = string.format("%d:%02.f", minutes, seconds)
        TimeToArrive.TimeText:SetText(tta)
    else
        TimeToArrive.TimeText:SetText("***")
    end
end

local function timeToArrive()
    local _, instanceType = IsInInstance()
    if (C_Map.HasUserWaypoint() == true or C_SuperTrack.IsSuperTrackingAnything() == true) and (instanceType == "none") then
        TimeToArrive:SetScript("OnUpdate", function(_, dt)
            elapsed = elapsed + dt
            if elapsed >= 1 then
                elapsed = 0
                local speed = GetUnitSpeed("player") or GetUnitSpeed("vehicle")
                local distance = C_Navigation.GetDistance()
                if not speed or speed == 0 then -- delta
                    C_Timer.After(1, function()
                        local currentDistance = C_Navigation.GetDistance()
                        speed = math.abs(currentDistance - distance)
                        setTime(currentDistance, speed)
                    end)
                else
                    setTime(distance, speed)
                end
            end
        end)
    else
        TimeToArrive:SetScript("OnUpdate", nil)
    end
end

function Module:OnEnable()
    elapsed = 0
	self:RegisterEvent("PLAYER_ENTERING_WORLD", timeToArrive)
	self:RegisterEvent("USER_WAYPOINT_UPDATED", timeToArrive)
    self:RegisterEvent("WAYPOINT_UPDATE", timeToArrive)
    self:RegisterEvent("SUPER_TRACKING_CHANGED", timeToArrive)
    TimeToArrive.TimeText:Show()
    timeToArrive()
end

function Module:OnDisable()
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	self:UnregisterEvent("USER_WAYPOINT_UPDATED")
    self:UnregisterEvent("WAYPOINT_UPDATE")
    self:UnregisterEvent("SUPER_TRACKING_CHANGED")
    TimeToArrive:SetScript("OnUpdate", nil)
    TimeToArrive.TimeText:Hide()
end

function Module:OnInitialize()
    TimeToArrive = CreateFrame("Frame", "TimeToArrive", UIParent)
    TimeToArrive.TimeText = TimeToArrive:CreateFontString(nil, "BACKGROUND", "GameFontNormal")
    TimeToArrive.TimeText:SetJustifyV("TOP")
    TimeToArrive.TimeText:SetSize(0, 26)
    TimeToArrive.TimeText:SetPoint("TOP", "SuperTrackedFrame", "BOTTOM", 0, -40)
    TimeToArrive.TimeText:SetParent(_G["SuperTrackedFrame"])
    TimeToArrive:SetParent(_G["SuperTrackedFrame"])
end

function Module:Info()
	return "Adds a feature to map pins showing an estimated time of arrival. It will display the time it will take for you to reach your destination based on your current speed and distance to travel. This can be especially useful for long journeys, giving you a better idea of when you will arrive at your destination."
end