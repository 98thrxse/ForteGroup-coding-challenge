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
        m.sideNav.visible = false
        m.top.insertChild(m.sideNav, 1)
    end if
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
