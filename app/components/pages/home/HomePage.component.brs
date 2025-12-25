sub init()
    m.top.id = "HomePage"
    m.cache = {}
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

    m.rowList.observeFieldScoped("rowItemFocused", "onRowItemFocused")
    m.rowList.observeFieldScoped("rowItemSelected", "onRowItemSelected")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub retrieveContent()
    cache = m.global.router.callFunc("loadFromCache", m.top.id)
    if cache <> invalid and cache.count() > 0 then
        showResult(cache.content, cache.showRowLabel)
        m.rowList.update({
            jumpToRowItem: cache.jumpToRowItem
        })
    else
        m.global.router.callFunc("setLoading", true)
        createFetchChannelsTask()
    end if
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

                showResult(contentNode, showRowLabel)
                m.global.router.callFunc("setLoading", false)
            end if
        end if
    end if
end sub

sub showResult(contentNode as object, showRowLabel as object)
    m.cache = {
        content: contentNode
        showRowLabel: showRowLabel
    }
    m.rowList.update(m.cache)
    m.global.router.callFunc("enableSideNav", m.top.id)
end sub

sub updateSafetyRegion(safetyRegion as object)
    horizMargin = safetyRegion[0]

    m.rowList.itemSize = [m.style.rowList.itemSize[0] - horizMargin, m.rowList.itemSize[1]]
end sub

sub onRowItemFocused(event as object)
    rowItemFocused = event.getData()
    m.cache.jumpToRowItem = rowItemFocused
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
    m.global.router.callFunc("saveToCache", m.top.id, m.cache)
    m.cache = invalid

    m.rowList.unobserveFieldScoped("rowItemSelected")
    m.rowList.unobserveFieldScoped("rowItemFocused")
    m.top.unobserveFieldScoped("focusedChild")

    if m.fetchChannelsTask <> invalid then
        m.fetchChannelsTask.unobserveFieldScoped("response")
        m.fetchChannelsTask.control = "stop"
    end if

    children = m.top.getChildren(-1, 0)
    for each item in children
        item.callFunc("destroy")
        m.top.removeChild(item)
        item = invalid
    end for
end sub
