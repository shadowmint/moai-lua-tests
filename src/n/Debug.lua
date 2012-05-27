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

-- Debugging tools
return function() 

  -- Public api
  local api = {}

  -- Private api
  local _api = {}

  -- Top level dump of an object
  api.dump = function(object)
    Log.debug("Dumping: " .. tostring(object))
    for k,v in pairs(object) do
      Log.debug("- " .. k .. " = " .. tostring(v))
    end
  end

  -- Recursive dump of an object
  api.rdump = function(object)
  end

  return api
end
