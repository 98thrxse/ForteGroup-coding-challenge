sub init()
    m.top.id = "HomePage"
    m.config = getHomePageConfig({})

    retrieveContent()
end sub

sub retrieveContent()
    m.global.router.callFunc("setLoading", true)
    createFetchChannelsTask()
end sub

sub createFetchChannelsTask()
    if m.fetchChannelsTask = invalid then
        m.fetchChannelsTask = createObject("roSGNode", "FetchChannelsTask")
    else
        m.fetchChannelsTask.control = "stop"
    end if

    m.fetchChannelsTask.functionName = "execute"
    m.fetchChannelsTask.observeFieldScoped("response", "onFetchChannelsTaskComplete")
    m.fetchChannelsTask.control = "run"
end sub

sub onFetchChannelsTaskComplete(event as object)
    if m.fetchChannelsTask <> invalid then
        m.fetchChannelsTask.unobserveFieldScoped("response")
        m.fetchChannelsTask.control = "stop"
    end if

    data = event.getData()
    if data <> invalid then
        content = data.content

        if content <> invalid then
            if not content.doesExist("error") then
                contentNode = createObject("roSGNode", "ContentNode")
                contentNode.update(content, true)

                m.global.router.callFunc("setLoading", false)
                m.global.router.callFunc("enableSideNav", m.top.id)
            end if
        end if
    end if
end sub

sub destroy()
    if m.fetchChannelsTask <> invalid then
        m.fetchChannelsTask.unobserveFieldScoped("response")
        m.fetchChannelsTask.control = "stop"
    end if

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
