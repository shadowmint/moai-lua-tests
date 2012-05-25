-- Testing helper
return function(_name, _done, _success)
   
  -- Check args
  local verify = function(name, value)
    if (value == nil) then
      print("Tests: Invalid argument: " .. name)
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
  pub.verify = function() 

    -- Cleanup success marker
    os.remove(donePath)
    os.remove(successPath)

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
      local fp = io.open(successPath, "w")
      fp:write("Success")
      fp:close()
    end

    -- Done
    local fp = io.open(donePath, "w")
    fp:write("Done")
    fp:close()
  end

  -- Pass out API
  return pub
end
