sub init()
    m.top.id = "SearchPage"
    m.config = getSearchPageConfig({})

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("enableSideNav", m.top.id)
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub updateSafetyRegion(_safetyRegion as object)
    m.keyboard.callFunc("setTranslationX")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if hasFocus then
        m.keyboard.setFocus(true)
    end if
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        item.callFunc("destroy")
        m.top.removeChild(item)
        item = invalid
    end for
end sub
