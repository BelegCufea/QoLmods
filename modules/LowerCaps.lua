local moduleName = "lower CAPS"

local QoLmods = select(2, ...)
local Module = QoLmods:NewModule(moduleName)

local LC_OrginalSendChatMessage

local function lower(str)
    if str == str:upper() then
        str = str:lower()
    elseif str:sub(2) == str:sub(2):upper() then
        str = str:sub(1, 1):upper() .. str:sub(2):lower()
    end
    return str
end

local function LC_SendChatMessage(msg, system, language, channel)
    if not LC_OrginalSendChatMessage then
        SendChatMessage(msg, system, language, channel)
    else
        msg = lower(msg)
        LC_OrginalSendChatMessage(msg, system, language, channel)
    end
end

function Module:OnEnable()
    LC_OrginalSendChatMessage = SendChatMessage
    SendChatMessage = LC_SendChatMessage
end

function Module:OnDisable()
    if LC_OrginalSendChatMessage then
        SendChatMessage = LC_OrginalSendChatMessage
        LC_OrginalSendChatMessage = nil
    end
end

function Module:OnInitialize()
end

function Module:Info()
	return "Converts CAPITALIZED text you send into chat to its lower case. It tries to combat `stuck` CAPS-LOCK. ('EXAMPLE' => 'example' or 'eXAMPLE' => 'Example')"
end