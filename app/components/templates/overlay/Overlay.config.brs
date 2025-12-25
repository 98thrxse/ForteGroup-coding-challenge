function getOverlayConfig(settings as object)
    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    sizes = {
        spinner: {
            FHD: {
                width: 128
                height: 128
                translation: [uiResolution.width / 2 - 64, uiResolution.height - 256]
            }
            HD: {
                width: 64
                height: 64
                translation: [uiResolution.width / 2 - 32, uiResolution.height - 128]
            }
        }
    }

    style = {
        image: {
            uri: "pkg:/assets/images/splash/" + screenSize + ".png"
            width: uiResolution.width
            height: uiResolution.height
        }
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
