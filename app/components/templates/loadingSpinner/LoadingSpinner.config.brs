function getLoadingSpinnerConfig(settings as object)
    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    sizes = {
        spinner: {
            FHD: {
                width: 128
                height: 128
                translation: [uiResolution.width / 2 - 64, uiResolution.height / 2 - 64]
            }
            HD: {
                width: 64
                height: 64
                translation: [uiResolution.width / 2 - 32, uiResolution.height / 2 - 32]
            }
        }
    }

    style = {
        spinner: {}
    }

    config = {
        sizes: {
            spinner: sizes.spinner[screenSize]
        }
        style: style
    }

    return config
end function
