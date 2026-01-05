sub execute()
    env = m.global.env
    config = getAPIConfig()
    base = config[env].channelsV2

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
            match = Instr(1, LCase(channel.title), LCase(text)) > 0 or _matchAcronym(channel.title, text)
        end if

        if channel.doesExist("path") and channel.path <> invalid then
            match = match or (Instr(1, LCase(channel.path), LCase(text)) > 0)
        end if

        if match then result.push(channel)
    end for

    return result
end function

function _matchAcronym(name as string, text as string) as boolean
    words = name.split(" ")
    acronym = ""

    for each word in words
        if not word.isEmpty() then
            firstChar = mid(word, 1, 1)
            if (firstChar >= "A" and firstChar <= "Z") or (firstChar >= "a" and firstChar <= "z") then
                acronym += firstChar
            end if

            for i = 1 to Len(word)
                c = mid(word, i, 1)
                if c >= "0" and c <= "9" then
                    acronym += c
                end if
            end for
        end if
    end for

    return LCase(left(acronym, len(text))) = LCase(text)
end function

sub _prepareChannels(channels as object)
    for each channel in channels
        if channel.doesExist("category") and channel.category <> invalid then
            channel.path = _getCategoryPath(channel.category)
        else
            channel.path = "Others"
        end if
    end for
end sub

function _sortByCategory(channels as object) as object
    map = {}

    _prepareChannels(channels)

    for each channel in channels
        isLive = false
        if channel.doesExist("isLive") and channel.isLive <> invalid then
            isLive = channel.isLive
        end if

        title = "Untitled"
        if channel.doesExist("title") and channel.title <> invalid and not channel.title.isEmpty() then
            title = channel.title
        end if

        category = channel.path
        if isLive then
            category += " - LIVE"
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

function _getCategoryPath(category as object) as string
    path = []

    if category.doesExist("name") and category.name <> invalid and not category.name.isEmpty() then
        path.push(category.name)
    end if

    if category.doesExist("subCategory") and category.subCategory <> invalid then
        subPath = _getCategoryPath(category.subCategory)
        if not subPath.isEmpty() then
            path.push(subPath)
        end if
    end if

    return path.join(" / ")
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
