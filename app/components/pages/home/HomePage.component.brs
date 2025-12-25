sub init()
    m.top.id = "HomePage"
    m.config = getHomePageConfig({
        safetyMargins: m.global.theme.safetyMargins
        uiResolution: m.global.deviceInfo.uiResolution
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    retrieveContent()

    m.rowList.observeFieldScoped("rowItemSelected", "onRowItemSelected")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
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
        showRowLabel = data.showRowLabel

        if content <> invalid then
            if not content.doesExist("error") then
                contentNode = createObject("roSGNode", "ContentNode")
                contentNode.update(content, true)

                m.rowList.update({
                    content: contentNode
                    showRowLabel: showRowLabel
                })
                m.global.router.callFunc("enableSideNav", m.top.id)
                m.global.router.callFunc("setLoading", false)
            end if
        end if
    end if
end sub

sub updateSafetyRegion(safetyRegion as object)
    horizMargin = safetyRegion[0]

    m.rowList.itemSize = [m.style.rowList.itemSize[0] - horizMargin, m.rowList.itemSize[1]]
end sub

sub onRowItemSelected(event as object)
    rowItemSelected = event.getData()

    rowIndex = rowItemSelected[0]
    itemIndex = rowItemSelected[1]

    row = m.rowList.content.getChild(rowIndex)
    item = row.getChild(itemIndex)

    routes = m.global.router.callFunc("getRoutes")
    details = routes.details
    m.global.router.callFunc("navigateToPage", details.id, item)
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.rowList <> invalid and hasFocus then
        m.rowList.setFocus(true)
    end if
end sub

sub destroy()
    m.rowList.unobserveFieldScoped("rowItemSelected")
    m.top.unobserveFieldScoped("focusedChild")

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
