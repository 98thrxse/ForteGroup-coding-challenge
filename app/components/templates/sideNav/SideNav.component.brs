sub init()
    m.routes = m.global.router.callFunc("getRoutes")
    m.colors = m.global.theme.colors

    m.config = getSideNavConfig({
        font: m.global.theme.font
        colors: m.colors
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    setButtonGroup()
    setWidth()

    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub setWidth(state = false as boolean)
    sideNav = m.config.sizes.sideNav
    width = sideNav.width[state.toStr()]

    m.background.width = width
    m.buttonGroup.update({
        maxWidth: width
        minWidth: width
    })

    m.top.width = width
end sub

sub setButtonGroup()
    for each route in m.routes.items()
        value = route.value
        sideNav = value.sideNav

        if sideNav.listed then
            button = createObject("roSGNode", "Button")
            button.id = value.id
            button.text = value.name
            button.observeFieldScoped("buttonSelected", "onButtonSelected")
            m.buttonGroup.appendChild(button)
        end if
    end for
end sub

sub onButtonSelected(event as object)
    id = event.getNode()
    m.global.router.callFunc("resetHistory")
    m.global.router.callFunc("navigateToPage", id)
end sub

sub onFocusChanged()
    isInFocusChain = m.top.isInFocusChain()
    childCount = m.buttonGroup.getChildCount()

    if childCount > 0 and isInFocusChain then
        setWidth(true)
        buttonFocused = m.buttonGroup.buttonFocused
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
    else
        setWidth(false)
    end if
end sub

sub updateButtons(id as string)
    if m.buttonGroup.getChildCount() > 0 then
        for each button in m.buttonGroup.getChildren(-1, 0)
            focusedIcon = button.getChild(3)
            icon = button.getChild(4)

            if button.id = id then
                focusedIcon.blendColor = m.colors.red
                icon.blendColor = m.colors.red
            else
                focusedIcon.blendColor = m.config.icons.focused
                icon.blendColor = m.config.icons.initial
            end if
        end for
    end if
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
