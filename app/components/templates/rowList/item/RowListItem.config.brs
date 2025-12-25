function getRowListItemConfig(settings as object)
    font = settings.font
    colors = settings.colors

    style = {
        image: {
            width: 210
            height: 295
        }
        textGroup: {
            translation: [0, 315]
        }
        title: {
            text: "N/A"
            width: 210
            font: font.smallestBold
        }
        isLive: {
            drawingStyles: {
                red: {
                    fontUri: font.smallest
                    color: colors.red
                },
                default: {
                    fontUri: font.smallest
                    color: colors.white
                }
            }
        }
    }

    config = {
        style: style
    }

    return config
end function
