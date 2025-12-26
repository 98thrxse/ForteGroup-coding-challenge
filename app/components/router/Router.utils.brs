sub _destroyPage()
    if m.page <> invalid then
        m.page.callFunc("destroy")

        m.top.removeChild(m.page)
        m.page = invalid
    end if
end sub

sub _createPage(pageName as string, content as object)
    m.page = createObject("roSGNode", pageName)
    m.page.callFunc("updateContent", content)

    m.top.insertChild(m.page, 0)
    m.page.setFocus(true)
end sub

sub _switchPage(pageName as string, content = {} as object)
    _destroyPage()
    _createPage(pageName, content)
    _onSideNavWidthChanged()
end sub

sub _createOverlay()
    if m.overlay = invalid then
        m.overlay = CreateObject("roSGNode", "Overlay")
        m.top.appendChild(m.overlay)
    end if
end sub

sub _createSpinner()
    if m.spinner = invalid then
        m.spinner = CreateObject("roSGNode", "LoadingSpinner")
        m.spinner.visible = false
        m.top.appendChild(m.spinner)
    end if
end sub

sub _createSideNav()
    if m.sideNav = invalid then
        m.sideNav = createObject("roSGNode", "SideNav")
        m.sideNav.observeFieldScoped("width", "_onSideNavWidthChanged")
        m.sideNav.visible = false
        m.top.insertChild(m.sideNav, 1)
    end if
end sub

sub _onSideNavWidthChanged()
    width = m.sideNav.width

    screenSize = m.uiResolution.name

    horizMargin = m.safetyMargins.horizontal[screenSize]
    vertMargin = m.safetyMargins.vertical[screenSize]

    translation = []
    isPlayer = m.page.id = m.routes.player.id

    if _hasSideNav() and not isPlayer then
        margin = width + horizMargin
        translation = [margin, vertMargin]

    else if _hasSideNav() and isPlayer then
        translation = [width, 0]

    else if not _hasSideNav() and not isPlayer then
        translation = [horizMargin, vertMargin]

    else if not _hasSideNav() and isPlayer then
        translation = [0, 0]
    end if

    m.page.callFunc("updateTranslation", translation)
    m.page.callFunc("updateSafetyRegion", translation)
end sub

function _hasSideNav() as boolean
    for each route in m.routes.items()
        value = route.value
        if value.id = m.page.id then
            sideNav = value.sideNav
            return sideNav.enabled
        end if
    end for

    return false
end function

sub _pushToHistory(id as string)
    m.history.push(id)
end sub

sub _popFromHistory()
    m.history.pop()
end sub

function _peekFromHistory() as string
    if m.history.count() > 0 then
        return m.history.peek()
    else
        return ""
    end if
end function
