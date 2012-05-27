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

-- Json loader
return function() 

  local api = {}

  -- extensions for this type
  api.ext = function()
    return "json"
  end

  -- load an actual object
  api.load = function(asset, path)
  	local fh = io.open(path, "r")
  	if (fh ~= nil) then
      local content = ""
      while true do
        local line = fh.read(fh)
        if not line then break end
        content = content .. line
      end 	
      asset.data = MOAIJsonParser.decode(content)
    end
  end

  return api
end
