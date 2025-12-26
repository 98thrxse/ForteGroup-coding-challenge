function getSearchPageConfig(settings as object)
    font = settings.font

    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    safetyMargins = settings.safetyMargins

    horizMargin = safetyMargins.horizontal[screenSize]
    vertMargin = safetyMargins.vertical[screenSize]

    sizes = {
        rowList: {
            FHD: {
                itemSpacing: [0, 80]
            }
            HD: {
                itemSpacing: [0, 40]
            }
        }
        keyboard: {
            FHD: {
                height: 300
            }
            HD: {
                height: 265
            }
        }
    }

    style = {
        hint: {
            font: font.largeBold
            horizAlign: "center"
            vertAlign: "center"
            width: uiResolution.width - horizMargin
            height: uiResolution.height
            text: "Type at least three letters to start your search…"
        }
        rowList: {
            numRows: 2
            rowTitleComponentName: "RowListLabel"
            itemComponentName: "RowListItem"
            itemSize: [uiResolution.width, 395]
            itemSpacing: sizes.rowList[screenSize].itemSpacing
            rowItemSpacing: [20, 0]
            rowItemSize: [[210, 295]]
            showRowLabel: [true]
            rowFocusAnimationStyle: "floatingFocus"
            vertFocusAnimationStyle: "floatingFocus"
            itemClippingRect: [
                0
                - vertMargin
                uiResolution.width
                uiResolution.height
            ]
            visible: false
        }
        keyboard: {}
    }

    config = {
        hint: {
            initial: style.hint.text
            empty: "No results.."
        }
        length: 3
        debounce: 0.5
        style: style
    }

    return config
end function
