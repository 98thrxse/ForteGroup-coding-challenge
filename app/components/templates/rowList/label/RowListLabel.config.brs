function getRowListLabelConfig(settings as object)
    font = settings.font

    style = {
        title: {
            translation: [0, -20]
            font: font.mediumBold
        }
    }

    config = {
        style: style
    }

    return config
end function
