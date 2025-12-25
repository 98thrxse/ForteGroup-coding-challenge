sub init()
    m.top.id = "DetailsPage"
    m.routes = m.global.router.callFunc("getRoutes")
    m.config = getDetailsConfig({
        font: m.global.theme.font
        safetyMargins: m.global.theme.safetyMargins
        colors: m.global.theme.colors
        uiResolution: m.global.deviceInfo.uiResolution
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        if m.[item.key] <> invalid then m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("enableSideNav", m.top.id)
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    childCount = m.buttonGroup.getChildCount()

    if childCount > 0 and hasFocus then
        buttonFocused = m.buttonGroup.buttonFocused
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
    end if
end sub

sub updateContent(content as object)
    m.content = content

    setImage()
    setTextGroup()
end sub

sub updateSafetyRegion(safetyRegion as object)
    horizMargin = safetyRegion[0]
    
    if m.title <> invalid then m.title.width = m.style.title.width - horizMargin
    if m.isLive <> invalid then m.isLive.width = m.style.isLive.width - horizMargin
    if m.category <> invalid then m.category.width = m.style.category.width - horizMargin
end sub

sub setImage()
    image = m.content.image
    if image <> invalid then
        if image.original <> invalid then
            m.image.uri = image.original
        else if image.medium <> invalid then
            m.image.uri = image.medium
        end if
    end if
end sub

sub setTextGroup()
    setTitle()
    setIsLive()
    setCategory()
    setButtonGroup()
end sub

sub setTitle()
    title = m.content.title
    if title <> invalid and not title.isEmpty() then
        m.title = createObject("roSGNode", "Label")
        m.title.update(m.style.title)
        m.title.text = title
        m.textGroup.appendChild(m.title)
    end if
end sub

sub setIsLive()
    isLive = m.content.isLive
    if isLive <> invalid and isLive then
        m.isLive = createObject("roSGNode", "MultiStyleLabel")
        m.isLive.update(m.style.isLive)
        m.isLive.text = "<red>●</red> LIVE"
        m.textGroup.appendChild(m.isLive)
    end if
end sub

sub setCategory()
    category = m.content.category
    if category <> invalid and not category.IsEmpty() then
        m.category = createObject("roSGNode", "Label")
        m.category.update(m.style.category)
        m.category.text += category
        m.textGroup.appendChild(m.category)
    end if
end sub

sub setButtonGroup()
    m.buttonGroup = createObject("roSGNode", "ButtonGroup")
    m.buttonGroup.update(m.style.buttonGroup)
    m.textGroup.appendChild(m.buttonGroup)

    setPlayButton()
    setBackButton()
end sub

sub setPlayButton()
    m.playButton = createObject("roSGNode", "Button")
    m.playButton.update(m.style.playButton)
    m.playButton.observeFieldScoped("buttonSelected", "onPlayButtonSelected")
    m.buttonGroup.appendChild(m.playButton)
end sub

sub setBackButton()
    m.backButton = createObject("roSGNode", "Button")
    m.backButton.update(m.style.backButton)
    m.backButton.observeFieldScoped("buttonSelected", "handleKeyBack")
    m.buttonGroup.appendChild(m.backButton)
end sub

sub onPlayButtonSelected()
    player = m.routes.player
    m.global.router.callFunc("navigateToPage", player.id, m.content)
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "left" then
        handled = handleKeyLeft()

    else if key = "right" then
        handled = handleKeyRight()

    else if key = "back" then
        handled = handleKeyBack()

    end if

    return handled
end function

function handleKeyLeft() as boolean
    childCount = m.buttonGroup.getChildCount()
    buttonFocused = m.buttonGroup.buttonFocused

    if childCount > 0 and buttonFocused > 0 then
        buttonFocused--
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
        return true
    end if

    return false
end function

function handleKeyRight() as boolean
    childCount = m.buttonGroup.getChildCount()
    buttonFocused = m.buttonGroup.buttonFocused

    if childCount > 0 and buttonFocused < childCount - 1 then
        buttonFocused++
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
        return true
    end if

    return false
end function

function handleKeyBack() as boolean
    m.global.router.callFunc("navigateBack")
    return true
end function
