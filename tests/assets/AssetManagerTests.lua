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

function setup()
  asset_manager_factory = require "n/assets/AssetManager"
  manager = asset_manager_factory()
  return manager
end

return {
  ["test_can_create_instance"] = function(t)
    local instance = setup()
    t.isNotNull(instance)
  end,

  ["test_cannot_load_missing_file"] = function(t)
    local instance = setup()

    local asset = instance.get("dummy_file.json")
    t.isNull(asset)

    asset = instance.get("dummy_file.BLAH")
    t.isNull(asset)
  end
}
