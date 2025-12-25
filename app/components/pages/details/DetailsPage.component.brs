sub init()
    m.top.id = "DetailsPage"
    m.config = getDetailsConfig({})

    m.global.router.callFunc("enableSideNav", m.top.id)
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
    m.global.router.callFunc("navigateBack")

    return true
end function

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
