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

-- A generic game asset of some type. 
-- <p>
-- Assets are really just a top level container for any kind of object
-- along with some tracking so we know who's using what assets.
-- Fetch asset instances from the AssetManager, and dispose of them
-- using drop().
return function(_manager)

  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      Log.error("Asset: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_manager", _manager) then return nil end

  -- Internal namespace
  local _api = {}
  
  -- Manager for this asset
  _api.manager = _manager
  
  -- Children assets
  _api.children = {}
  
  -- Children meta data
  _api.childmeta = {
  	["count"] = 0,
  }

  -- Public api
  local api = { ["_api"] = _api }

  -- This asset is no longer required here
  api.drop = function()
    manager.drop(api)
  end
  
  -- Set a child asset by id
  api.set = function(id, value) 
   	if (value) then
  	  	_api.childmeta.count = api.childmeta.count + 1
  	  	_api.children[id] = value
   	else
   		if (get(id) ~= nil) then
  		  	_api.childmeta.count = api.childmeta.count - 1
  		  	_api.children[id] = nil
   		end
   	end 
  end
  
  -- Get a child asset by id
  api.get = function(id) 
  	return _api.children[id]
  end
  
  -- The name or id of this asset (usually path)
  api.id = nil

  -- Actual asset data
  api.data = nil

  return api
end
