function keySelected(key as string) as boolean
    handled = false

    if key = "left" then
        handled = handleKeyLeft()

    else if key = "right" then
        handled = handleKeyRight()

    else if key = "shift" then
        handled = handleKeyShift()

    else if key = "capslock" then
        handled = handleKeyCapsLock()

    else if key = "abc123" then
        handled = handleKeyABC()

    else if key = "symbols" then
        handled = handleKeySymbols()

    else if key = "accents" then
        handled = handleKeyAccents()
    end if

    return handled
end function

function handleKeyLeft() as boolean
    m.top.textEditBox.cursorPosition = m.top.textEditBox.cursorPosition - 1
    return true
end function

function handleKeyRight() as boolean
    m.textEditBox.cursorPosition = m.textEditBox.cursorPosition + 1
    return true
end function

function handleKeyShift() as boolean
    if m.keyGrid.mode = "ABC123Lower" then
        m.keyGrid.mode = "ABC123Shift"

    else if m.keyGrid.mode = "ABC123Shift" then
        m.keyGrid.mode = "ABC123Lower"

    else if m.keyGrid.mode = "SymbolsLower" then
        m.keyGrid.mode = "SymbolsShift"

    else if m.keyGrid.mode = "SymbolsShift" then
        m.keyGrid.mode = "SymbolsLower"

    else if m.keyGrid.mode = "AccentsLower" then
        m.keyGrid.mode = "AccentsShift"

    else if m.keyGrid.mode = "AccentsShift" then
        m.keyGrid.mode = "AccentsLower"
    end if

    return true
end function

function handleKeyCapsLock() as boolean
    if m.keyGrid.mode = "ABC123Lower" or m.keyGrid.mode = "ABC123Shift" then
        m.keyGrid.mode = "ABC123Upper"

    else if m.keyGrid.mode = "ABC123Upper" then
        m.keyGrid.mode = "ABC123Lower"

    else if m.keyGrid.mode = "SymbolsLower" or m.keyGrid.mode = "SymbolsShift" then
        m.keyGrid.mode = "SymbolsUpper"

    else if m.keyGrid.mode = "SymbolsUpper" then
        m.keyGrid.mode = "SymbolsLower"

    else if m.keyGrid.mode = "AccentsLower" or m.keyGrid.mode = "AccentsShift" then
        m.keyGrid.mode = "AccentsUpper"

    else if m.keyGrid.mode = "AccentsUpper" then
        m.keyGrid.mode = "AccentsLower"
    end if

    return true
end function

function handleKeyABC() as boolean
    if m.keyGrid.mode = "SymbolsUpper" or m.keyGrid.mode = "AccentsUpper" then
        m.keyGrid.mode = "ABC123Upper"
    else
        m.keyGrid.mode = "ABC123Lower"
    end if

    return true
end function

function handleKeySymbols() as boolean
    if m.keyGrid.mode = "ABC123Upper" or m.keyGrid.mode = "AccentsUpper" then
        m.keyGrid.mode = "SymbolsUpper"
    else
        m.keyGrid.mode = "SymbolsLower"
    end if

    return true
end function

function handleKeyAccents() as boolean
    if m.keyGrid.mode = "ABC123Upper" or m.keyGrid.mode = "SymbolsUpper" then
        m.keyGrid.mode = "AccentsUpper"
    else
        m.keyGrid.mode = "AccentsLower"
    end if

    return true
end function
