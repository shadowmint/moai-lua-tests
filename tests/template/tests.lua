local test = _G["test"]

-- Example
test.bind("example_test", function(t)
  t.isTrue(true, "True is true")
  t.isTrue(false, "False is true?")
end)
