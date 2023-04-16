local QoLmods = select(2, ...)

local CONST = {}
QoLmods.CONST = CONST

CONST.METADATA = {
    NAME = GetAddOnMetadata(..., "Title"),
    VERSION = GetAddOnMetadata(..., "Version")
}