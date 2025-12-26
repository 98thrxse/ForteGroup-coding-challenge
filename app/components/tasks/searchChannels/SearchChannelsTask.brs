sub execute()
    env = m.global.env
    config = getAPIConfig()
    base = config[env].base

    request = m.top.request
    text = request.text

    rawResponse = ReadAsciiFile(base)
    if not rawResponse.isEmpty() then
        jsonResponse = parseJson(rawResponse)
        if jsonResponse <> invalid then
            response = _searchByTitleOrCategory(jsonResponse, text)
            m.top.response = response
        else
            m.top.response = {
                error: "invalid"
            }
        end if
    end if
end sub

function _searchByTitleOrCategory(channels as object, text as string) as object
    return _sortByCategory(_findByTitleOrCategory(channels, text))
end function

function _findByTitleOrCategory(channels as object, text as string) as object
    result = []

    for each channel in channels
        match = false

        if channel.doesExist("title") and channel.title <> invalid then
            match = Instr(1, LCase(channel.title), LCase(text)) > 0
        end if

        if not match and channel.doesExist("category") and channel.category <> invalid then
            match = Instr(1, LCase(channel.category), LCase(text)) > 0
        end if

        if match then result.push(channel)
    end for

    return result
end function

function _sortByCategory(channels as object) as object
    map = {}

    for each channel in channels
        isLive = false
        if channel.doesExist("isLive") and channel.isLive <> invalid then
            isLive = channel.isLive
        end if

        title = "Untitled"
        if channel.doesExist("title") and channel.title <> invalid and not channel.title.isEmpty() then
            title = channel.title
        end if

        category = "Others"
        if channel.doesExist("category") and channel.category <> invalid and not channel.category.isEmpty() then
            category = channel.category

            if isLive then
                category += " - LIVE"
            end if
        end if

        if not map.doesExist(category) then
            map[category] = []
        end if

        image = {
            original: "pkg:/assets/images/rowList/placeholder.png"
            medium: "pkg:/assets/images/rowList/placeholder.png"
        }
        if channel.doesExist("image") and channel.image <> invalid then
            image.original = channel.image.original
            image.medium = channel.image.medium
        end if

        item = {
            id: channel.id
            title: title
            isLive: isLive
            image: image
            video: _pickRandomVideo()
            category: category
        }

        map[category].push(item)
    end for

    ' optionally sort live channels first
    ' for each category in map.keys()
    '     map[category] = _sortLiveFirst(map[category])
    ' end for

    content = []
    showRowLabel = []

    for each category in map.keys()
        showRowLabel.push(category <> invalid and not category.isEmpty())

        content.push({
            title: category
            children: map[category]
        })
    end for

    contentNode = createObject("roSGNode", "ContentNode")
    contentNode.update(content, true)

    return {
        content: contentNode
        showRowLabel: showRowLabel
    }
end function

function _pickRandomVideo() as object
    random = (Rnd(0) < 0.5)

    if random then
        video = {
            streamFormat: "hls"
            url: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8"
        }
    else
        video = {
            streamFormat: "dash"
            url: "https://storage.googleapis.com/wvmedia/cenc/h264/tears/tears.mpd"
            drmParams: {
                keySystem: "widevine",
                licenseServerURL: "https://proxy.uat.widevine.com/proxy?provider=widevine_test"
            }
        }
    end if

    return video
end function
