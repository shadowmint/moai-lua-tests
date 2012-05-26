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

-- Setup
terminal_factory = require "n/terminal"
terminal = terminal_factory(512, 512, "assets/Roboto-Medium.ttf", 13, 30)

-- Help message
terminal.attach("help", "show help message", function() 
  terminal.help()
end)

-- Print an environment variable
terminal.attach("env", "print an environment variable", function(args) 
  if args[2] then
    local value = MOAIEnvironment[args[2]]
    terminal.trace(": " .. tostring(value))
  else
    terminal.trace("Usage: env [TARGET]")
  end
end)

-- Close terminal
terminal.attach("exit", "close terminal", function() 
  terminal.hide()
end)

-- GO!
terminal.trace("debug terminal. Type 'help' for help.")
terminal.show()
