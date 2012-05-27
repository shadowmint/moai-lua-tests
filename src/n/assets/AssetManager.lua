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

  -- Set of loaded assets
  _api.assets = {}

  -- Base path for assets; if this is set it acts as a prefix
  _api.root = nil

  -- Setup various asset loaders
  _api.setup = function() 
    local lf = require "n/assets/ILoader"
    local l = {}
    table.insert(l, (require "n/assets/JsonLoader")())
    for k,v in pairs(l) do
      local loader = lf(v)
      if (loader ~= nil) then
        _api.loaders[v.ext()] = loader
      end
    end
  end

  -- Ends helper
  _api.ends = function(string, ends)
    return ends=='' or string.sub(string,-string.len(ends))==ends
  end

  -- Figure out what loader to use and load an asset
  _api.load = function(path)
    local rtn = nil
    local loader = nil
    for k,v in pairs(_api.loaders) do
      if (_api.ends(path, k)) then
        loader = v
      end
    end
    if (loader == nil) then
      Log.error("Unable to determine loader for: " .. path)
    else
      local asset = loader.load(api, path)
      if (asset.data == nil) then
        Log.error("Unable to load asset for: " .. path)
      else
        rtn = {
          ["count"] = 1,
          ["asset"] = asset
        }
      end
    end
    return rtn
  end

  -- Set the root path for the asset manager
  -- @param path The root path, complete with trailing slash
  api.setRoot = function(path)
    _api.root = path
  end

  -- Request an asset by path
  -- <p>
  -- Attempts to auto resolve the type of the asset from the path
  -- itself; if the asset can't be loaded it returns nil
  api.get = function(path)
    local rtn = nil
    if (_api.root ~= nil) then
      path = root .. path
    end
    if (_api.assets[path] ~= nil) then
      local ah = _api.assets[path]
      ah.count = ah.count + 1
      rtn = ah.asset
    end
    if (rtn == nil) then
      local ah = _api.load(path)
      if (ah ~= nil) then
        _api.assets[path] = ah
        rtn = ah.asset
      end
    end
    return rtn
  end

  -- Drop an asset
  api.drop = function(asset)
    if (_api.assets[asset.id] ~= nil) then
      local ah = _api.assets[asset.id]
      ah.count = ah.count - 1
      if (ah.count <= 0) then
        _api.assets[asset.id] = nil
      end
    end
    return rtn
  end

  -- Prints a breakdown of loaded assets to the terminal
  api.breakdown = function(terminal)
    for k,v in pairs(_api.assets) do
      Log.info("AssetManager: Loaded asset breakdown:")
      Log.info("- " .. k .. " has " .. v.count .. " references")
    end
  end
  
  -- Return a new blank asset
  api.asset = function()
  	local rtn = _api.asset_factory(api)
  	return rtn
  end

  _api.setup()
  return api
end
