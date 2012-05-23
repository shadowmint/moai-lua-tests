-- Testing framework
test = require "helpers/test"

-- Check we can create an instance
test.verify(function() 
  factory = require "n/terminal"
  return true
end, "Unable to import terminal factory")

-- Check we can create a terminal instance
test.verify(function() 
  MOAISim.openWindow ( "test", 512, 512 )
  terminal = factory(512, 512, "assets/Roboto-Medium.ttf", 14, 10)
  return true
end, "Unable to create terminal instance")

-- Check we can log to the terminal
test.verify(function() 
  terminal.trace("Hello World 1")
  terminal.trace("Hello World 2")
  terminal.trace("Hello World 3")
  terminal.trace("Hello World 4")
  terminal.trace("Hello World 5")
  return true
end, "Unable to trace messages")

-- Check we can hide the terminal
test.verify(function()
  terminal.hide()
  return true
end, "Unable to hide terminal")

-- Check we can show the terminal
test.verify(function() 
  terminal.show()
  return true
end, "Unable to show terminal")

-- Check we can attach a terminal command and run it
test.verify(function()
  terminal.show()
  local success = false

  -- Attach handler
  terminal.attach("RUN", function() 
    success = true
  end)

  -- Try to invoke
  terminal.handle("RUN")
  return success
end, "Unable to attach terminal command")

-- DONE
return test
