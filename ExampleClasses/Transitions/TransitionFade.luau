local ReplicatedStorage = game:GetService("ReplicatedStorage")

local nodekit = require(ReplicatedStorage.Packages.nodekit)

local TransitionFade = {}
TransitionFade.__index = TransitionFade
setmetatable(TransitionFade, { __index = nodekit.Transition })

type FadeOptions = {
  color: Color3?,
}

function TransitionFade:create(opts: FadeOptions?)
	local inst = setmetatable(nodekit.Transition:create(), TransitionFade)
  inst._color = (opts and opts.color) or Color3.new(0, 0, 0)
  return inst
end

function TransitionFade:run(duration: number, incoming: any, outgoing: any, finish: () -> ())
  local done = false
  local function finalize()
    if done then
      return
    end
    done = true
    finish()
  end

  if not duration or duration <= 0 then
    finalize()
    return
  end

	local parent = self._getRootGuiParent(incoming, outgoing)
  if not parent then
    finalize()
    return
  end

	local overlay = nodekit.Node.Frame:create("TransitionFadeOverlay")
    :setSize(UDim2.fromScale(1, 1))
    :setPosition(UDim2.fromScale(.5, .5))
    :setAnchorPoint(Vector2.new(.5, .5))
    :setBackgroundColor3(self._color)
    :setBackgroundTransparency(1)
    :setBorderSizePixel(0)
    :setActive(false)
  parent:addChild(overlay)

  local half = duration * .5
  local tweenIn = overlay:tween(half, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):toBackgroundTransparency(0)
  local tweenOut = overlay:tween(half, Enum.EasingStyle.Quad, Enum.EasingDirection.In):toBackgroundTransparency(1)

  tweenIn:onCompleted(function()
    if outgoing then
      outgoing:setVisible(false)
    end

    tweenOut:onCompleted(function()
      overlay:destroy()
      finalize()
    end)

    incoming:setVisible(true)
    tweenOut:play()
  end)

  tweenIn:play()
end

return TransitionFade
