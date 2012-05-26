-- Setup
test_factory = require "n/test"
test = test_factory("Hello World", ".done.txt", ".success.txt")

test.bind("test_hello", function(t)
  t.isTrue(1 == 1, "Check: 1 == 1")
  t.isTrue(1 == 2, "Check: 1 == 2")
  t.isTrue(1 == 3, "Check: 1 == 3")
  t.isTrue(1 == 4, "Check: 1 == 4")
end)

test.bind("test_world", function(t)
  t.isTrue(1 == 1, "Check: 1 == 1")
  t.isTrue(1 == 2, "Check: 1 == 2")
  t.isTrue(true, "Check: true")
  t.isTrue(false, "Check: false")
end)

test.verify("junk.txt")
