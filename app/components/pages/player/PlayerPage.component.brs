sub init()
    m.top.id = "PlayerPage"
    m.config = getPlayerPageConfig({})

    m.global.router.callFunc("enableSideNav", m.top.id)
end sub

sub updateContent(content as object)
    m.content = content
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "back" then
        handled = handleKeyBack()
    end if

    return handled
end function

function handleKeyBack() as boolean
    m.global.router.callFunc("navigateBack", m.content)

    return true
end function

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
