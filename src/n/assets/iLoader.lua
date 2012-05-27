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

-- Any asset loader should implement this interface.
return function(impl) 

  -- Apis
  local _api = {}
  local api = { ["_api"] = _api }
  
  -- hook: return extension
  _api.ext = function() 
    return ""
  end
  
  -- hook: load asset
  _api.load = function(asset, path)
  end
  
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

  -- Rebind implementation to hooks if possible
  for k,v in pairs(_api) do
    if (impl[k] == nil) then
      Log.error("ILoader: Invalid implementation: Does not implement " .. k)
      api = nil
      break
    else
      _api[k] = impl[k]
    end
  end

  return api
end
