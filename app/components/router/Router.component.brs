sub setup()
    m.routes = getRoutes()

    _createOverlay()
    _createSpinner()

    home = m.routes.home
    navigateToPage(home.id)
end sub

sub navigateToPage(pageName as string, content = {} as object)
    _switchPage(pageName, content)
end sub
