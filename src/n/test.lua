-- Testing helper
return function(_name)
   
  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      print("Tests: Invalid argument: " .. name)
      return true
    end
    return false
  end
  if verify("_name", _name) then return nil end

  -- api
  local pub = {}

  -- test api
  local pubTester = {}

  -- Name of this test set
  local name = _name

  -- Set of all tests 
  local tests = {}

  -- Number of held tests
  local testCount = 0

  -- Currently running test
  local currentTest = nil

  -- Assert some value is true
  -- @param value The value that should be true
  -- @param message The error to display if not true
  pubTester.isTrue = function(value, message)
    if not value then
      currentTest.errorCount = currentTest.errorCount + 1
      table.insert(currentTest.errors, message)
    end
  end

  -- Attach a named test
  -- 
  -- The request must be a function in the form:
  -- function(tester) ... end
  --
  -- Inside the test function any number of calls to
  -- tester.assert(condition, "error code") can be called.
  --
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

  -- Run all the tests and report back about how they went
  pub.verify = function(result_file) 

    -- Cleanup success marker
    os.remove(result_file)

    -- Run tests
    print("\nRunning tests: " .. name)
    local failed = false
    for k, v in pairs(tests) do
      print("running: " .. v.name)
      currentTest = v
      v.request(pubTester);
    end

    -- Print summary
    print("\nTest summary:")
    for k, v in pairs(tests) do
      if (v.errorCount > 0) then
        print("\n" .. v.name .. " failed with " .. v.errorCount .. " errors")
        for ek, ev in pairs(v.errors) do
          print("- " .. ev)
          failed = true
        end
      else
        print(name .. " passed")
      end
    end
    if (not failed) then
      print("\n" .. name .. " PASSED\n")
    else
      print("\n" .. name .. " FAILED\n")
    end

    -- Generate test result file
    if (not failed) then
      local fp = io.open(result_file, "w")
      fp:write("Success")
      fp:close()
    end

    -- Done
    error("Error to exit test suite!")
  end

  -- Pass out API
  return pub
end
