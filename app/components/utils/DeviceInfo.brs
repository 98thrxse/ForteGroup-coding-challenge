function getDeviceInfo()
    deviceInfo = createObject("roDeviceInfo")
    return {
        uiResolution: _getUIResolution(deviceInfo)
    }
end function

function _getUIResolution(deviceInfo as object) as object
    return deviceInfo.getUIResolution()
end function
