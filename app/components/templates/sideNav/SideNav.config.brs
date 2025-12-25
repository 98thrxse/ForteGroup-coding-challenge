function getSideNavConfig(settings as object)
    colors = settings.colors

    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    sizes = {
        sideNav: {
            FHD: {
                width: {
                    true: 384
                    false: 110
                }
            }
            HD: {
                width: {
                    true: 256
                    false: 70
                }
            }
        }
    }

    style = {
        background: {
            height: uiResolution.height
            color: colors.black
        }
        buttonGroup: {
            layoutDirection: "vert"
            vertAlignment: "center"
            translation: [0, uiResolution.height / 2]
        }
    }

    config = {
        sizes: {
            sideNav: sizes.sideNav[screenSize]
        }
        icons: {
            initial: 255
            focused: -16843009
        }
        style: style
    }

    return config
end function
