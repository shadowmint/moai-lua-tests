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

-- Singleton
local _instance = nil

-- Global logging tools; this is a singleton.
local factory = function() 

  local _api = {}
  local api = { ["_api"] = _api }

  -- Log levels
  -- <p>
  -- Lua doesn't support bit flags; you can set the level
  -- to one of these, but not an arbitrary combination.
  api.ERROR = 1
  api.INFO = 2
  api.DEBUG = 3

  -- Terminal if one is attached
  _api.term = nil

  -- Current log level
  _api.level = api.ERROR

  -- Log a message
  _api.log = function(level, message) 
    if (_api.level >= level) then
      if (_api.term ~= nil) then
        _api.term.trace(message)
      end
      print(message)
    end
  end

  -- Debug message
  api.debug = function(msg)
    _api.log(api.DEBUG, msg)
  end

  -- Info message
  api.info = function(msg)
    _api.log(api.INFO, msg)
  end

  -- Error message
  api.error = function(msg)
    _api.log(api.ERROR, msg)
  end

  -- Set the terminal to log to
  api.setTerminal = function(term) 
    _api.term = term
  end

  -- Set the log level
  api.setLogLevel = function(level)
    _api.level = level
  end

  -- Force output
  -- <p>
  -- Yes, this makes things slow. So turn logging off if you
  -- dont like it. Buffering output so we never see it on errors
  -- is stupid.
  io.stdout:setvbuf("no")

  return api
end

-- Attach to global namespace
if (_instance == nil) then
  _instance = factory()
  _G["Log"] = _instance
end
