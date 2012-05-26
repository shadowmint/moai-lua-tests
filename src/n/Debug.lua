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

-- Debugging tools
-- @param _terminal The terminal to log to
return function(_terminal) 

  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      print("Debug: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_terminal", _terminal) then return nil end

  -- Public api
  local api = {}

  -- Private api
  local _api = {}

  -- Terminal 
  local term = _terminal

  -- Top level dump of an object
  api.dump = function(object)
  end

  -- Recursive dump of an object
  api.rdump = function(object)
  end

  return api
end
