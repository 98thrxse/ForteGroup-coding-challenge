sub init()
    m.top.id = "PlayerPage"
    m.config = getPlayerPageConfig({
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("resetCache")
    m.global.router.callFunc("enableSideNav", m.top.id)
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.video <> invalid and hasFocus then
        m.video.setFocus(true)
    end if
end sub

sub updateContent(content as object)
    m.content = content
    setVideo()
end sub

sub setVideo()
    video = m.content.video
    if video <> invalid then
        videoContent = createObject("RoSGNode", "ContentNode")

        videoContent.url = video.url
        videoContent.streamformat = video.streamFormat
        videoContent.drmParams = video.drmParams

        title = m.content.title
        if title <> invalid then
            videoContent.title = title
        end if

        m.video.content = videoContent
        m.video.control = "play"
    end if
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
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        item.callFunc("destroy")
        m.top.removeChild(item)
        item = invalid
    end for
end sub
