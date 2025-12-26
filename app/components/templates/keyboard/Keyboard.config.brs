function getKeyboardConfig(settings as object)
    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    safetyMargins = settings.safetyMargins
    horizMargin = safetyMargins.horizontal[screenSize]
    vertMargin = safetyMargins.vertical[screenSize]

    colors = settings.colors

    style = {
        background: {
            color: colors.background
        }
        keyboard: {
            translation: [uiResolution.width / 2 - horizMargin, uiResolution.height - vertMargin]
        }
        keyGrid: {
            keyDefinitionUri: "pkg:/components/configs/keyboard.json"
            mode: "ABC123Lower"
        }
        textEditBox: {
            hintText: "Search"
        }
    }

    config = {
        style: style
    }

    return config
end function
