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
-- Use get() to fetch asset singletons and drop to give notice that
-- you're not using the asset any more. 
return function() 

  -- Public api
  local api = {}

  -- Private api
  local _api = {}

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

  return api
end
