sub setup()
    m.routes = getRoutes()

    m.uiResolution = m.global.deviceInfo.uiResolution
    m.safetyMargins = m.global.theme.safetyMargins
    m.startup = m.global.startup

    _createSideNav()
    _createOverlay()
    _createSpinner()

    home = m.routes.home
    navigateToPage(home.id)
end sub

sub navigateToPage(pageName as string, content = {} as object)
    _switchPage(pageName, content)
end sub

sub setLoading(visible as boolean)
    if m.startup then
        m.overlay.visible = visible
    else
        m.spinner.visible = visible
    end if

    if m.startup and not m.overlay.visible then
        m.startup = false
        m.global.update({ startup: m.startup })
    end if
end sub

sub enableSideNav(id as string)
    for each route in m.routes.items()
        value = route.value
        if value.id = id then
            sideNav = value.sideNav
            m.sideNav.visible = sideNav.enabled
            m.sideNav.callFunc("updateButtons", id)
        end if
    end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "back" then
        handled = handleKeyBack()
    else if key = "left" then
        handled = handleKeyLeft()
    else if key = "right" then
        handled = handleKeyRight()
    end if

    return handled
end function

function handleKeyBack() as boolean
    return true
end function

function handleKeyLeft() as boolean
    if m.sideNav.visible and m.page.isInFocusChain() then
        m.sideNav.setFocus(true)
    end if

    return true
end function

function handleKeyRight() as boolean
    if m.page.visible and m.sideNav.isInFocusChain() then
        m.page.setFocus(true)
    end if

    return true
end function
