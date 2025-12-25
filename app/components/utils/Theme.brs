function getTheme() as object
    return {
        colors: _getColors()
        safetyMargins: _getSafetyMargins()
        font: _getFont()
    }
end function

function _getColors() as object
    return {
        background: "#222222"
        white: "#FFFFFF"
        black: "#000000"
        red: "#FF0000"
    }
end function

function _getSafetyMargins() as object
    return {
        horizontal: {
            HD: 64
            FHD: 96
        }
        vertical: {
            HD: 40
            FHD: 56
        }
    }
end function

function _getFont() as object
    return {
        smallest: "font:SmallestSystemFont"
        smallestBold: "font:SmallestBoldSystemFont"
        small: "font:SmallSystemFont"
        smallBold: "font:SmallBoldSystemFont"
        medium: "font:MediumSystemFont"
        mediumBold: "font:MediumBoldSystemFont"
        large: "font:LargeSystemFont"
        largeBold: "font:LargeBoldSystemFont"
    }
end function
