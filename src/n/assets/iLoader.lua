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

-- Any asset loader should implement this interface.
return function() 

  -- Public api
  local api = {}
  
  -- Implementation hook
  api.impl = {
  	["ext"] = nil, -- string function()
  	["load"] = nil -- void function(asset, path) 
  }

  -- Return the extension that this loader is valid for.
  api.ext = function(object)
  	return api.impl.ext()
  end

  -- Load the Asset for this loader and return it.
  -- @param manager The asset manager
  -- @param path The path to the asset
  api.load = function(manager, path)
  	local asset = manager.asset()
  	return impl.load()
  end

  return api
end
