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

-- Looks after assets and loading assets.
-- <p>
-- Use get to fetch asset singletons and drop to give notice that
-- you're not using the asset any more. 
return function() 

  -- Private api
  local _api = {}
  
  -- Public api
  local api = { ["_api"] = _api }

  -- Local asset factory
  _api.asset_factory = require "n/assets/Asset";

  -- Set of loaders
  _api.loaders = {}

  -- Setup various asset loaders
  _api.setup = function() 
    local lf = require "n/assets/ILoader"
    local l = {}
    table.insert(l, (require "n/assets/JsonLoader")())
    for k,v in pairs(l) do
      local loader = lf(v)
      if (loader ~= nil) then
        _api.loaders[v.ext()] = v
      end
    end
  end

  -- Request an asset by path
  -- <p>
  -- Attempts to auto resolve the type of the asset from the path
  -- itself; 
  api.get = function(path)
  end

  -- Drop an asset
  api.drop = function(asset)
  end

  -- Prints a breakdown of loaded assets to the terminal
  api.breakdown = function(terminal)
  end
  
  -- Return a new blank asset
  api.asset = function()
  	local rtn = _api.asset_factory(api)
  	return rtn
  end

  _api.setup()
  return api
end
