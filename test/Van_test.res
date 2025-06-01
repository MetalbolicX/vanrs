open Test
open Assertion

// DOM bindings
@val external document: Dom.document = "document"
@send external createElement: (Dom.document, string) => Dom.element = "createElement"
@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
@send external querySelector: (Dom.element, string) => Nullable.t<Dom.element> = "querySelector"
@send external remove: Dom.element => unit = "remove"
@get external body: Dom.document => Dom.element = "body"
@get external textContent: Dom.element => string = "textContent"
@set external setTextContent: (Dom.element, string) => unit = "textContent"
@set external setId: (Dom.element, string) => unit = "id"
@get external getId: Dom.element => string = "id"

// Test utilities
let setup: unit => Dom.element = () => {
  let element = document->createElement("div")
  element->setId("100")
  element->setTextContent("Hello Rescript test")

  let textArea = document->createElement("textarea")
  element->appendChild(textArea)

  document->body->appendChild(element)
  element
}

let teardown: Dom.element => unit = element => element->remove

test("Van.state object is initialized with a value", () => {
  let counter = Van.state(0)
  isIntEqualTo(counter.val, 0, ~message="Initial value should be 0")
})

test("Van.state object value is updated", () => {
  let counter = Van.state(0)
  counter.val = 42
  isIntEqualTo(counter.val, 42, ~message="Updated value should be 42")
})

test("Van.derive object create a derived state object", () => {
  let counter = Van.state(2)
  let doubleCounter = Van.derive(() => 2 * counter.val)
  isIntEqualTo(doubleCounter.val, 4, ~message="Derived value should be 4")
})

// test(
//   "Van.add and Van.Tags.createTag check if a new element was added to the DOM using Van js framework",
//   () => {
//     let container = setup()

//     Van.add(
//       container,
//       Van.Dom.createElement("span")->Van.Dom.setAttrs({"id": "test"})->Van.Dom.build,
//     )->ignore
//     switch container->querySelector("#test") {
//     | Value(_) =>
//       isTruthy(
//         true,
//         ~message="The span element with id 'test' was correctly added using the Van.add function. In addition it was added using the Van.Tags.createTag function.",
//       )
//     | Null | Undefined =>
//       isTruthy(
//         false,
//         ~message="The span element with id 'test' was not correctly added using the Van.add function",
//       )
//     }

//     container->teardown
//   },
// )
