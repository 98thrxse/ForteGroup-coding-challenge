sub init()
    m.config = getRowListLabelConfig({
        font: m.global.theme.font
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.top.observeFieldScoped("content", "onContentChanged")
end sub

sub onContentChanged(event as object)
    m.content = event.getData()

    if m.content <> invalid then
        setTitle()
    end if
end sub

sub setTitle()
    title = m.content.title
    if title <> invalid then
        m.title.text = title
    end if
end sub
