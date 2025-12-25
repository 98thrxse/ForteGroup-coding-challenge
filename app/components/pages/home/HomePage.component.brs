sub init()
    m.top.id = "HomePage"
    m.config = getHomePageConfig({})

    m.global.router.callFunc("enableSideNav", m.top.id)
end sub

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
