sub _debounceCreateTimer(observerCallback as string)
    m._debounceTimer = createObject("roSGNode", "Timer")
    m._debounceTimer.observeFieldScoped("fire", observerCallback)
    m._debounceTimer.duration = m._debounceTime
    m._debounceTimer.control = "start"
end sub

sub _debounceStopTimer()
    if m._debounceTimer <> invalid then
        m._debounceTimer.control = "stop"
        m._debounceTimer.unObserveFieldScoped("fire")
        m._debounceTimer = invalid
    end if
end sub

sub _debounceFuncCaller()
    if m._debounceFunc <> invalid and m._debounceFuncEvent <> invalid then
        m._debounceFunc(m._debounceFuncEvent)
    end if
end sub

function debounce(func as function, time as float) as function
    m._debounceFunc = func
    m._debounceTime = time

    return sub(event as object)
        m._debounceFuncEvent = event

        _debounceStopTimer()
        _debounceCreateTimer("_debounceFuncCaller")
    end sub
end function
