local ADDON_NAME = ...;
local QoLmods = LibStub("AceAddon-3.0"):NewAddon(select(2, ...), ADDON_NAME, "AceConsole-3.0")

local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Const = QoLmods.CONST
local Debug = QoLmods.DEBUG

QoLmods.defaults = {
    profile = {
        Enabled = true,
        Debug = false,
        modules = {},
    },
}

local function getTTSVoices()
    local voices = C_VoiceChat.GetTtsVoices()
    local voiceOptions = {}
    if voices then
        for _, voice in ipairs(voices) do
            voiceOptions[voice.voiceID] = voice.name
        end
    end
    return voiceOptions
end

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
            order = 10,
            args = {},
        },
        tts = {
            type = "group",
            name = "TTS Voices",
            order = 20,
            args ={
                info = {
                    type = "description",
                    name = "These settings allow you to change the default WoW TTS voices otherwise available in the Accessibility section.",
                    order = 0,
                    width = "full",
                    fontSize = "large",
                },
                blank1 = {
                    type = "header",
                    name = "",
                    order = 1,
                },
                speed = {
                    type = "range",
                    name = "Rate of Speech",
                    order = 6,
                    min = TEXTTOSPEECH_RATE_MIN,
                    max = TEXTTOSPEECH_RATE_MAX,
                    get = function(info)
                        return C_TTSSettings.GetSpeechRate()
                    end,
                    set = function(info, value)
                        C_TTSSettings.SetSpeechRate(value)
                    end,
                },
                valume = {
                    type = "range",
                    name = "Speech volume",
                    order = 7,
                    min = 0,
                    max = 100,
                    get = function(info)
                        return C_TTSSettings.GetSpeechVolume()
                    end,
                    set = function(info, value)
                        C_TTSSettings.SetSpeechVolume(value)
                    end,
                },
                standard = {
                    type = "select",
                    name = "Standard voice",
                    order = 10,
                    width = "full",
                    values = function()
                        return getTTSVoices()
                    end,
                    get = function(info)
                        return C_TTSSettings.GetVoiceOptionID(0)
                    end,
                    set = function(info, value)
                        C_TTSSettings.SetVoiceOption(0, value)
                    end,
                    style = "dropdown",
                },
                standardTest = {
                    type = "execute",
                    name = "Test",
                    order = 12,
                    width = "half",
                    func = function()
                        local voiceID = C_TTSSettings.GetVoiceOptionID(0)
                        local rate = C_TTSSettings.GetSpeechRate()
                        local volume = C_TTSSettings.GetSpeechVolume()
                        C_VoiceChat.SpeakText(voiceID, "This is a test of standard voice.", Enum.VoiceTtsDestination.LocalPlayback, rate, volume)
                    end
                },
                alternate = {
                    type = "select",
                    name = "Alternate voice",
                    order = 20,
                    width = "full",
                    values = function()
                        return getTTSVoices()
                    end,
                    get = function(info)
                        return C_TTSSettings.GetVoiceOptionID(1)
                    end,
                    set = function(info, value)
                        C_TTSSettings.SetVoiceOption(1, value)
                    end,
                    style = "dropdown",
                },
                alternateTest = {
                    type = "execute",
                    name = "Test",
                    order = 22,
                    width = "half",
                    func = function()
                        local voiceID = C_TTSSettings.GetVoiceOptionID(1)
                        local rate = C_TTSSettings.GetSpeechRate()
                        local volume = C_TTSSettings.GetSpeechVolume()
                        C_VoiceChat.SpeakText(voiceID, "This is a test of alternate voice.", Enum.VoiceTtsDestination.LocalPlayback, rate, volume)
                    end
                }
            },
        },
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