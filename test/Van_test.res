open Test
open Assertion

test("Van.state object is initialized with a value", () => {
  let counter = Van.state(0)
  checkIntEqual(counter.val, 0, ~message="Initial value should be 0")
})

test("Van.state object value is updated", () => {
  let counter = Van.state(0)
  counter.val = 42
  checkIntEqual(counter.val, 42, ~message="Updated value should be 42")
})

test("Van.derive object create a derived state object", () => {
  let counter = Van.state(2)
  let doubleCounter = Van.derive(() => {
    Console.log("Derive function called")
    2 * counter.val
  })
  checkIntEqual(doubleCounter.val, 4, ~message="Derived value should be 4")

  // Update the original state and check derived state
  counter.val = 3
  Console.log2(counter.val, doubleCounter)
  checkIntEqual(doubleCounter.val, 6, ~message="Derived value should be updated to 6")
})