sub init()
    m.top.id = "SearchPage"
    m.config = getSearchPageConfig({})

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("enableSideNav", m.top.id)

    m.keyboard.observeFieldScoped("text", "onKeyboardTextChanged")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onKeyboardTextChanged(event as object)
    text = event.getData()

    hasLength = text.len() >= m.config.length
    m.global.router.callFunc("setLoading", hasLength)

    if hasLength then
        createSearchChannelsTask(text)
    end if
end sub

sub createSearchChannelsTask(text as string)
    if m.searchChannelsTask = invalid then
        m.searchChannelsTask = createObject("roSGNode", "SearchChannelsTask")
    else
        m.searchChannelsTask.control = "stop"
    end if

    m.searchChannelsTask.request = { text: text }
    m.searchChannelsTask.functionName = "execute"
    m.searchChannelsTask.observeFieldScoped("response", "onSearchChannelsTaskComplete")
    m.searchChannelsTask.control = "run"
end sub

sub onSearchChannelsTaskComplete(event as object)
    if m.searchChannelsTask <> invalid then
        m.searchChannelsTask.unobserveFieldScoped("response")
        m.searchChannelsTask.control = "stop"
    end if

    data = event.getData()
    if data <> invalid then
        content = data.content
        showRowLabel = data.showRowLabel

        if content <> invalid then
            if not content.doesExist("error") then
                if content.children.count() > 0 then
                    contentNode = createObject("roSGNode", "ContentNode")
                    contentNode.update(content, true)
                end if

                m.global.router.callFunc("setLoading", false)
            end if
        end if
    end if
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

    if m.searchChannelsTask <> invalid then
        m.searchChannelsTask.unobserveFieldScoped("response")
        m.searchChannelsTask.control = "stop"
    end if

    children = m.top.getChildren(-1, 0)
    for each item in children
        item.callFunc("destroy")
        m.top.removeChild(item)
        item = invalid
    end for
end sub
