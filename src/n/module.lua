-- This is a module; anything until the 'return' statement is a 
-- single local scope. The 'return' returns an instance of the 
-- api by running the function.
return (function()
   
   -- List container
   local data = {}

   -- Public api
   local pub = {}
           
   -- Add an item to the list
   pub.add = function(key, value)
     local element = { key = key, value = value }
     data[key] = element
   end

   -- Print all the items in the list
   pub.print = function() 
     for i = 0, 10, 1 do
     print(i)
     end 
     for k, v in pairs(data) do
     print("KEY " .. v.key .. " // VALUE " .. v.value)
     end
   end

 -- Pass out API
 return pub
end)()
