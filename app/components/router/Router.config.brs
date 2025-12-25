function getRoutes() as object
    return {
        home: {
            name: "Home"
            id: "HomePage"
            sideNav: {
                listed: true
                enabled: true
            }
        }
        details: {
            name: "Details"
            id: "DetailsPage"
            sideNav: {
                listed: false
                enabled: true
            }
        }
        player: {
            name: "Player"
            id: "PlayerPage"
            sideNav: {
                listed: false
                enabled: false
            }
        }
        search: {
            name: "Search"
            id: "SearchPage"
            sideNav: {
                listed: true
                enabled: true
            }
        }
    }
end function
