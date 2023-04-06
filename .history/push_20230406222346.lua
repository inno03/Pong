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
  table.insert(canvases, { name = "_render" }) 

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

function push:setCanvas(name)
  if not self._canvas then return true end
  return love.graphics.setCanvas( self:getCanvasTable(name).canvas )
end
function push:getCanvasTable(name)
  for i = 1, #self.canvases do
    if self.canvases[i].name == name then
      return self.canvases[i]
    end
  end
end
function push:setShader(name, shader)
  if not shader then
    self:getCanvasTable("_render").shader = name
  else
    self:getCanvasTable(name).shader = shader
  end
end

function push:initValues()
  self._PSCALE = self._highdpi and love.window.getPixelScale() or 1
  
  self._SCALE = {
    x = self._RWIDTH/self._WWIDTH * self._PSCALE,
    y = self._RHEIGHT/self._WHEIGHT * self._PSCALE
  }
  
  if self._stretched then --if stretched, no need to apply offset
    self._OFFSET = {x = 0, y = 0}
  else
    local scale = math.min(self._SCALE.x, self._SCALE.y)
    if self._pixelperfect then scale = math.floor(scale) end
    
    self._OFFSET = {x = (self._SCALE.x - scale) * (self._WWIDTH/2), y = (self._SCALE.y - scale) * (self._WHEIGHT/2)}
    self._SCALE.x, self._SCALE.y = scale, scale 
  end
  
  self._GWIDTH = self._RWIDTH * self._PSCALE - self._OFFSET.x * 2
  self._GHEIGHT = self._RHEIGHT * self._PSCALE - self._OFFSET.y * 2
end