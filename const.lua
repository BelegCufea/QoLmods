local QoLmods = select(2, ...)

local CONST = {}
QoLmods.CONST = CONST

CONST.METADATA = {
    NAME = C_AddOns.GetAddOnMetadata(..., "Title"),
    VERSION = C_AddOns.GetAddOnMetadata(..., "Version")
}