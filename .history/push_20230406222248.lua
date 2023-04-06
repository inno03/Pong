local push = {
  
  defaults = {
    fullscreen = false,
    resizable = false,
    pixelperfect = false,
    highdpi = true,
    canvas = true
  }
  
}
setmetatable(push, push)

function push:applySettings(settings)
  for k, v in pairs(settings) do
    self["_" .. k] = v
  end
end

function push:resetSettings() return self:applySettings(self.defaults) end

function push:setupScreen(WWIDTH, WHEIGHT, RWIDTH, RHEIGHT, settings)

  settings = settings or {}

  self._WWIDTH, self._WHEIGHT = WWIDTH, WHEIGHT
  self._RWIDTH, self._RHEIGHT = RWIDTH, RHEIGHT

  self:applySettings(self.defaults) 
  self:applySettings(settings) 
  
  love.window.setMode( self._RWIDTH, self._RHEIGHT, {
    fullscreen = self._fullscreen,
    resizable = self._resizable,
    highdpi = self._highdpi
  } )

  self:initValues()

  if self._canvas then
    self:setupCanvas({ "default" }) 
  end

  self._borderColor = {0, 0, 0}

  self._drawFunctions = {
    ["start"] = self.start,
    ["end"] = self.finish
  }

  return self
end

function push:setupCanvas(canvases)
  table.insert(canvases, { name = "_render" }) --final render

  self._canvas = true
  self.canvases = {}

  for i = 1, #canvases do
    self.canvases[i] = {
      name = canvases[i].name,
      shader = canvases[i].shader,
      canvas = love.graphics.newCanvas(self._WWIDTH, self._WHEIGHT)
    }
  end

  return self
end