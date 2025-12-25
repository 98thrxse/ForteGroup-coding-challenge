sub init()
  router = m.top.findNode("Router")

  m.global.update({
    env: "prod"
    deviceInfo: getDeviceInfo()
    theme: getTheme()
    router: router
    startup: true
  }, true)

  setAppBackgroundColor()

  router.callFunc("setup")
end sub

sub setAppBackgroundColor()
  scene = m.top.getScene()
  scene.backgroundColor = m.global.theme.colors.background
  scene.backgroundUri = ""
end sub
