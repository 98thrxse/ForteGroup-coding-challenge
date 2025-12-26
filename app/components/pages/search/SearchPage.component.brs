sub init()
    m.top.id = "SearchPage"
    m.cache = {}
    m.config = getSearchPageConfig({
        font: m.global.theme.font
        uiResolution: m.global.deviceInfo.uiResolution
        safetyMargins: m.global.theme.safetyMargins
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    retrieveContent()

    m.lastFocused = invalid
    m.onKeyboardTextDebounced = debounce(onKeyboardTextChanged, m.config.debounce)
    m.global.router.callFunc("enableSideNav", m.top.id)

    m.rowList.observeFieldScoped("rowItemFocused", "onRowItemFocused")
    m.rowList.observeFieldScoped("rowItemSelected", "onRowItemSelected")
    m.keyboard.observeFieldScoped("text", "callOnKeyboardTextDebounced")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub retrieveContent()
    cache = m.global.router.callFunc("loadFromCache", m.top.id)
    if cache <> invalid and cache.count() > 0 then
        m.keyboard.text = cache.text
        showResult(cache.content, cache.showRowLabel)
        m.rowList.update({
            jumpToRowItem: cache.jumpToRowItem
        })
    end if
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

sub callOnKeyboardTextDebounced(event as object)
    m.onKeyboardTextDebounced(event)
end sub

sub onKeyboardTextChanged(event as object)
    text = event.getData()

    hasLength = text.len() >= m.config.length
    m.global.router.callFunc("setLoading", hasLength)

    if hasLength then
        createSearchChannelsTask(text)
    else
        showInitialHint()
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
    if data <> invalid and not data.doesExist("error") then
        content = data.content
        showRowLabel = data.showRowLabel

        if content <> invalid then
            if content.getChildCount() > 0 then
                showResult(content, showRowLabel)
            else
                showEmptyResult()
            end if

            m.global.router.callFunc("setLoading", false)
        end if
    end if
end sub

sub showResult(content as object, showRowLabel as object, jumpToRowItem = [0, 0] as object)
    m.hint.visible = false
    m.rowList.visible = true

    m.cache = {
        content: content
        showRowLabel: showRowLabel
        text: m.keyboard.text
    }
    m.rowList.update(m.cache)
end sub

sub showEmptyResult()
    m.rowList.visible = false
    m.hint.visible = true

    m.hint.text = m.config.hint.empty

    m.global.router.callFunc("removeFromCache", m.top.id)
end sub

sub showInitialHint()
    m.rowList.visible = false
    m.hint.visible = true

    m.hint.text = m.config.hint.initial

    m.global.router.callFunc("removeFromCache", m.top.id)
end sub

sub updateSafetyRegion(safetyRegion as object)
    horizMargin = safetyRegion[0]

    m.hint.width = m.style.hint.width - horizMargin
    m.rowList.itemSize = [m.style.rowList.itemSize[0] - horizMargin, m.rowList.itemSize[1]]
    m.keyboard.callFunc("setTranslationX")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if hasFocus then
        if m.lastFocused <> invalid then
            m.lastFocused.setFocus(true)
        else
            m.keyboard.setFocus(true)
        end if
    end if
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "up" then
        handled = handleKeyUp()

    else if key = "down" then
        handled = handleKeyDown()

    else if key = "options" then
        handled = handleKeyOptions()

    else if key = "back" then
        handled = handleKeyBack()
    end if

    return handled
end function

function handleKeyUp() as boolean
    if m.rowList.content <> invalid and m.rowList.visible then
        m.rowList.setFocus(true)
        m.lastFocused = m.rowList
    end if

    return true
end function

function handleKeyDown() as boolean
    m.keyboard.setFocus(true)
    m.lastFocused = m.keyboard

    return true
end function

function handleKeyBack() as boolean
    m.global.router.callFunc("navigateBack")

    return true
end function

function handleKeyOptions() as boolean
    if m.rowList.hasFocus() then
        m.keyboard.setFocus(true)

    else if m.rowList.content <> invalid and m.rowList.visible then
        m.rowList.setFocus(true)
    end if

    return true
end function

sub destroy()
    m.global.router.callFunc("saveToCache", m.top.id, m.cache)
    m.cache = invalid

    m.lastFocused = invalid
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
