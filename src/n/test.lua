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

-- Testing helper
return function(_name, _done, _success)
   
  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      Log.error("Test: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_name", _name) then return nil end
  if verify("_done", _done) then return nil end
  if verify("_success", _success) then return nil end

  -- api
  local pub = {}

  -- test api
  local pubTester = {}

  -- Name of this test set
  local name = _name

  -- Create this file when we're done
  local donePath = _done

  -- Create this file on success
  local successPath = _success

  -- Set of all tests 
  local tests = {}

  -- Number of held tests
  local testCount = 0

  -- Currently running test
  local currentTest = nil

  -- Assert some value is false
  -- @param value The value that should be false
  -- @param message The error to display if not false
  pubTester.isFalse = function(value, message)
    if value then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected false)")
    end
  end

  -- Assert some value is true
  -- @param value The value that should be true
  -- @param message The error to display if not true
  pubTester.isTrue = function(value, message)
    if not value then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected true)")
    end
  end
  
  -- Assert two values are not equal
  -- @param actual The actual value
  -- @param not_expected The value we expected not to get
  -- @param message The error to display if not true
  pubTester.isNotEqual = function(actual, not_expected, message)
    if actual == not_expected then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected anything but " .. not_expected .. ")")
    end
  end

  -- Assert two values are equal
  -- @param actual The actual value
  -- @param expected The expected value
  -- @param message The error to display if not true
  pubTester.isEqual = function(actual, expected, message)
    if actual ~= expected then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected " .. expected .. " but got " .. actual .. ")")
    end
  end

  -- Assert value is nil
  -- @param value The actual value
  -- @param message The error to display if not true
  pubTester.isNull = function(value, message)
    if value ~= nil then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected nil but got " .. tostring(value) .. ")")
    end
  end

  -- Assert two values are equal
  -- @param value The actual value
  -- @param message The error to display if not true
  pubTester.isNotNull = function(value, message)
    if value == nil then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message .. " (expected not nil)")
    end
  end

  -- Attach a named test
  -- <p>
  -- The request must be a function in the form:
  -- function(tester) ... end
  -- <p>
  -- Inside the test function any number of calls to
  -- tester.assert(condition, "error code") can be called.
  -- @param name The name of the test
  -- @param request The verifier function itself
  pub.bind = function(name, request) 
    local test = {
      ["name"] = name,
      ["request"] = request,
      ["errorCount"] = 0,
      ["errors"] = {}
    }
    tests[name] = test
  end

  -- Attach a set of named tests
  -- <p>
  -- The set in the form { "name" = function } is attached to
  -- the test set using the form bind(namespace .. name, function)
  -- @param namespace The namespace for this set of tests
  -- @param tests A table of tests
  pub.bindTests = function(namespace, tests) 
    for k,v in pairs(tests) do
      pub.bind(namespace .. k, v)
    end
  end

  -- Run all the tests and report back about how they went
  pub.verify = function() 

    -- Cleanup success marker
    os.remove(donePath)
    os.remove(successPath)

    -- Run tests
    Log.info("\nRunning tests: " .. name)
    local failed = false
    for k, v in pairs(tests) do
      Log.info("running: " .. v.name)
      currentTest = v
      v.request(pubTester);
    end

    -- Print summary
    Log.info("\nTest summary:")
    failed_tests = 0
    for k, v in pairs(tests) do
      if (v.errorCount > 0) then
        Log.info("\n" .. v.name .. " failed with " .. v.errorCount .. " errors")
        for ek, ev in pairs(v.errors) do
          Log.info("- " .. ev)
          failed = true
        end
        failed_tests = failed_tests + 1
      else
        Log.info(v.name .. " passed")
      end
    end
    if (not failed) then
      Log.info("\n" .. name .. " PASSED\n")
    else
      Log.info("\n" .. name .. " FAILED\n")
    end

    -- Generate test result file
    if (not failed) then
      local fp = io.open(successPath, "w")
      fp:write("Success")
      fp:close()
    end

    -- Done
    local fp = io.open(donePath, "w")
    fp:write("Done")
    fp:close()

    return failed_tests
  end

  -- Pass out API
  return pub
end
