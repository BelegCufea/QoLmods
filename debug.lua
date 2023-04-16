local QoLmods = select(2, ...)

local DEBUG = {}
QoLmods.DEBUG = DEBUG

local Const = QoLmods.CONST

function DEBUG:Info(value, name, type)
    if not QoLmods.db.profile.Debug then return end
    if not name then name = Const.METADATA.NAME end

    if (not type) or (type == "Print") then
        QoLmods:Print(name, value)
        return
    end

    if (type == "VDT") and ViragDevTool_AddData then
        ViragDevTool_AddData(value, Const.METADATA.NAME .. "_" .. name)
        return
    end

end