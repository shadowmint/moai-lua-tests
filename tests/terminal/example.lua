-- Setup
MOAISim.openWindow ( "test", 512, 512 )
terminal_factory = require "n/terminal"
terminal = terminal_factory(512, 512, "assets/Roboto-Medium.ttf", 13, 10)
terminal.show()

-- Testing function
terminal.attach("Hello", function() 
  terminal.trace("Success! Victory!")
end)

-- Quit function
terminal.attach("quit", function() 
  error("Deliberately terminated application")
end)

-- GO!
terminal.trace("Hello World!")
terminal.trace("Basic commands are: Hello, quit")
