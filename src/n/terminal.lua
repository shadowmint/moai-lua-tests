-- Copyright 2012 Douglas Linder
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICEnsE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIOns OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

require "n/Log"

-- Terminal emulator
-- @param _width The width in units for the text area.
-- @param _height The height in units for the text area.
-- @param _fontPath The path to the font to use.
-- @param _fontSize The font size to use.
-- @param _maxLines The maximum number of lines to display.
return function(_width, _height, _fontPath, _fontSize, _maxLines)

  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      Log.error("Terminal: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_width", _width) then return nil end
  if verify("_height", _height) then return nil; end;
  if verify("_fontPath", _fontPath) then return nil; end;
  if verify("_fontSize", _fontSize) then return nil; end;
  if verify("_maxLines", _maxLines) then return nil; end;

  -- Public api
  local api = {}

  -- Private api
  local _api = {}

  -- Terminal font
  local font = nil

  -- Layer for the terminal
  local layer = nil

  -- Text box for drawing in
  local textbox = nil

  -- Are we currently visible?
  local visible = false

  -- Number of lines held
  local size = 0

  -- Lines of visible output
  local lines = {}

  -- Maximum lines to allow
  local maxLines = _maxLines

  -- Font size
  local fontSize = _fontSize

  -- Textbox for the cli
  local cli = nil

  -- Current cli buffer
  local cliBuffer = ""

  -- The current set of bound commands
  local commands = {}
  
  -- Create one of these
  _api.setup = function() 
    
    -- Load the font
    charcodes = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-'
    font = MOAIFont.new()
    font:load(_fontPath)
    font:preloadGlyphs(charcodes, fontSize)
    
    -- Create a layer and attach it
    viewport = MOAIViewport.new()
    viewport:setSize(_width, _height)
    viewport:setScale(_width, -_height)
    layer = MOAILayer2D.new()
    layer:setViewport(viewport)

    -- Correct size so we have a tiny border
    width = _width * 0.95
    height = _height * 0.95

    -- Create a textbox
    style = MOAITextStyle.new()
    style:setFont(font)
    style:setSize(fontSize)
    textbox = MOAITextBox.new()
    textbox:setStyle(style)
    textbox:setRect(-width / 2, -height / 2, width / 2, height / 2)
    textbox:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.LEFT_JUSTIFY)
    layer:insertProp(textbox)

    -- Cli text box
    cli = MOAITextBox.new()
    cli:setStyle(style)
    cli:setRect(-width / 2, height/2 - 20, width / 2, height)
    cli:setAlignment(MOAITextBox.LEFT_JUSTIFY, MOAITextBox.LEFT_JUSTIFY)
    layer:insertProp(cli)

    -- Make the terminal visible
    MOAISim.pushRenderPass(layer)
  end

  -- Keyboard handler
  _api.handleInput = function(key, down) 
    if (not down) then
      if key == 13 then
        api.handle(cliBuffer)
        cliBuffer = ""
      elseif key == 127 then
        cliBuffer = string.sub(cliBuffer, 0, cliBuffer:len() - 1)
      else
        cliBuffer = cliBuffer .. string.char(key)
      end
      cli:setString(cliBuffer)
      cli:revealAll()
    end
  end

  -- Exploder
  -- credit: http://richard.warburton.it
  _api.explode = function(str)
    local div = " "
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
      table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
      pos = sp + 1 -- Jump past current divider
    end
    table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
    return arr
  end

  -- Enable keyboard listener
  _api.enableInput = function() 
    MOAIInputMgr.device.keyboard:setCallback(_api.handleInput)
  end
  
  -- Disable keyboard listener
  _api.disableInput = function() 
    MOAIInputMgr.device.keyboard:setCallback(nil)
  end

  -- Destroy self
  api.destroy = function() 
    layer:clear()
    MOAISim:removeRenderPass(layer)
  end
  
  -- Handle arbitrary event commands
  api.handle = function(cmd) 
    success = false
    args = _api.explode(cmd)
    for k,v in pairs(commands) do
      if (k == args[1]) then
        api.trace("Running: " .. cmd)
        v.command(args)
        success = true
        break
      end
    end
    if (not success) then
      api.trace("Invalid command: " .. cmd)
    end
  end

  -- Attach a command to the terminal
  api.attach = function(trigger, help, command) 
    commands[trigger] = {
      ["command"] = command,
      ["help"] = help,
      ["trigger"] = trigger
    }
  end

  -- Print a line to the terminal
  api.trace = function(msg)
    msg = tostring(msg)
    table.insert(lines, msg .. "\n")
    size = size + 1
    if (size > maxLines) then
      table.remove(lines, 1)
      size = size - 1
    end
    if visible then
      api.show()
    end
  end

  -- Show the layer (or redraw)
  api.show = function()
    output = ""
    for k, v in pairs(lines) do
      output = output .. v;
    end
    textbox:setString(output)
    textbox:revealAll()
    if (not visible) then
      visible = true
      _api.enableInput()
    end
  end

  -- Show help message~
  api.help = function() 
    for k, v in pairs(commands) do
      api.trace(v.trigger .. ": " .. v.help)
    end
  end

  -- Hide the layer
  api.hide = function() 
    layer:clear()
    if (visible) then
      visible = false
      _api.disableInput()
    end
  end

  _api.setup()
  return api
end
