sub init()
    m.config = getRowListItemConfig({
        font: m.global.theme.font
        colors: m.global.theme.colors
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.top.observeFieldScoped("itemContent", "onItemContentChanged")
end sub

sub onItemContentChanged(event as object)
    m.itemContent = event.getData()

    if m.itemContent <> invalid then
        setImage()
        setTitle()
        setIsLive()
    end if
end sub

sub setImage()
    image = m.itemContent.image
    if image <> invalid then
        if image.medium <> invalid then
            m.image.uri = image.medium
        else if image.original <> invalid then
            m.image.uri = image.original
        end if
    end if
end sub

sub setTitle()
    title = m.itemContent.title
    if title <> invalid and not title.isEmpty() then
        m.title.text = title
    end if
end sub

sub setIsLive()
    isLive = m.itemContent.isLive
    if isLive <> invalid and isLive then
        m.isLive.text = "<red>●</red> LIVE"
    end if
end sub
