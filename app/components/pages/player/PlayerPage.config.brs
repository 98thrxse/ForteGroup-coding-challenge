function getPlayerPageConfig(settings as object)
    uiResolution = settings.uiResolution

    style = {
        video: {
            width: uiResolution.width
            height: uiResolution.height
        }
    }

    config = {
        style: style
    }

    return config
end function
