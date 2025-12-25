sub init()
  router = m.top.findNode("Router")

  m.global.update({
    env: "prod"
    router: router
  }, true)

  setAppBackgroundColor()

  router.callFunc("setup")
end sub

sub setAppBackgroundColor()
  scene = m.top.getScene()
  scene.backgroundUri = ""
end sub
