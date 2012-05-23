-- This is a module; anything until the 'return' statement is a 
-- single local scope. The 'return' returns an instance of the 
-- api by running the function.
return (function()
   
  -- api
  local pub = {}

  -- List container
  local failed = false

  -- Run a function and assert success as result
  pub.verify = function(request, msg)
    rtn = request()
    pub.assert(rtn, msg)
  end

  -- Assert some value is true
  -- @param value The value that should be true
  -- @param message The error to display if not true
  pub.assert = function(value, message)
    if (not value) then
      failed = true
      print("Error: " .. message)
    end
  end

  -- Generate a file at the given path if tests passed.
  pub.done = function(result_file) 
    if (not failed) then
      fp = io.open(result_file, "w")
      fp:write("Success")
      fp:close()
      print("Success!")
    else
      print("Failed")
    end
    error("Error to exit test suite!")
  end

  -- Pass out API
  return pub
end)()
