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

-- A generic game asset of some type. 
-- <p>
-- Assets are really just a top level container for any kind of object
-- along with some tracking so we know who's using what assets.
-- Fetch asset instances from the AssetManager, and dispose of them
-- using drop().
return function(_manager, _data) 

  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      print("Debug: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_manager", _manager) then return nil end
  if verify("_data", _data) then return nil end

  -- Manager for this asset
  local manager = _manager

  -- Public api
  local api = {}

  -- This asset is no longer required here
  api.drop = function()
    manager.drop(api)
  end

  -- Actual asset data
  api.data = _data

  return api
end
