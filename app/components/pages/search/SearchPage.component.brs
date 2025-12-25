sub init()
    m.top.id = "SearchPage"
    m.config = getSearchPageConfig({})

    m.global.router.callFunc("enableSideNav", m.top.id)
end sub

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        item.callFunc("destroy")
        m.top.removeChild(item)
        item = invalid
    end for
end sub
