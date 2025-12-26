sub init()
    m.uiResolution = m.global.deviceInfo.uiResolution
    m.config = getKeyboardConfig({
        uiResolution: m.uiResolution
        safetyMargins: m.global.theme.safetyMargins
        colors: m.global.theme.colors
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        if m.[item.key] <> invalid then m.[item.key].update(item.value)
    end for

    setKeyboard()
    setBackground()

    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub setKeyboard()
    m.keyGrid = m.top.keyGrid
    m.textEditBox = m.top.textEditBox

    m.textEditBox.update(m.style.textEditBox)
    m.textEditBox.observeFieldScoped("text", "onTextChanged")

    m.keyGrid.update(m.style.keyGrid)

    setTranslationX()
    setTranslationY()
end sub

sub setTranslationX()
    keyboardBound = m.top.sceneBoundingRect()

    if keyboardBound.x + keyboardBound.width >= m.uiResolution.width then
        x = 0
    else
        x = m.style.keyboard.translation[0] - keyboardBound.width / 2
    end if

    m.top.translation = [x, m.top.translation[1]]
end sub

sub setTranslationY(isInFocusChain = false as boolean)
    keyboardBound = m.top.sceneBoundingRect()
    textEditBoxBound = m.textEditBox.boundingRect()

    if isInFocusChain then
        y = m.style.keyboard.translation[1] - keyboardBound.height
    else
        y = m.style.keyboard.translation[1] - textEditBoxBound.height
    end if

    m.top.translation = [m.top.translation[0], y]
end sub

sub setBackground()
    keyboardBound = m.top.boundingRect()

    m.background = createObject("roSGNode", "Rectangle")
    m.background.width = keyboardBound.width
    m.background.height = keyboardBound.height
    m.background.update(m.style.background)
    
    m.top.insertChild(m.background, 0)
end sub

sub onTextChanged(event as object)
    m.top.text = event.getData()
end sub

sub onFocusChanged()
    isInFocusChain = m.top.isInFocusChain()
    if m.isInFocusChain = isInFocusChain then return

    m.isInFocusChain = isInFocusChain
    setTranslationY(m.isInFocusChain)
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
