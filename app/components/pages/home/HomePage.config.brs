function getHomePageConfig(settings as object)
    safetyMargins = settings.safetyMargins

    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    vertMargin = safetyMargins.vertical[screenSize]

    sizes = {
        rowList: {
            FHD: {
                numRows: 2
                itemSpacing: [0, 80]
            }
            HD: {
                numRows: 1
                itemSpacing: [0, 40]
            }
        }
    }

    style = {
        rowList: {
            numRows: sizes.rowList[screenSize].numRows
            rowTitleComponentName: "RowListLabel"
            itemComponentName: "RowListItem"
            itemSize: [uiResolution.width, 395]
            itemSpacing: sizes.rowList[screenSize].itemSpacing
            rowItemSpacing: [20, 0]
            rowItemSize: [[210, 295]]
            rowFocusAnimationStyle: "floatingFocus"
            vertFocusAnimationStyle: "floatingFocus"
            itemClippingRect: [
                0
                -vertMargin
                uiResolution.width
                uiResolution.height
            ]
        }
    }

    config = {
        style: style
    }

    return config
end function
