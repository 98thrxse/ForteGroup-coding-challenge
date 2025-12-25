sub init()
    m.config = getOverlayConfig({
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    setSpinnerPoster()
end sub

sub setSpinnerPoster()
    if m.spinner <> invalid then
        sizes = m.config.sizes

        m.spinner.poster.uri = "pkg:/assets/images/spinner.png"
        m.spinner.poster.width = sizes.spinner.width
        m.spinner.poster.height = sizes.spinner.height
        m.spinner.poster.translation = sizes.spinner.translation
    end if
end sub

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
