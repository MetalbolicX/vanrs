/**
 * Adds child DOM elements or other valid children to a parent DOM element.
 * @param parent The parent DOM element.
 * @param children A variadic list of children to add.
 * @returns The parent DOM element for chaining.
 */

let add: (Dom.element, 'a) => Dom.element

/**
 * Represents a state object with a mutable `val` field.
 */
type state<'a> = {mutable val: 'a}

/**
 * Creates a new state object.
 * @param initialValue The initial value of the state.
 * @returns A state object with a mutable `val` field.
 */
let state: 'a => state<'a>

/**
 * Creates a derived state object based on a derivation function.
 * @param deriveFn A function that derives a value based on other states.
 * @returns A derived state object that updates automatically.
 */
let derive: (unit => 'a) => state<'a>

/**
 * Hydrates the SSR component dom with the hydration function f.
 * @param dom The root DOM node of the SSR component we want to hydrate.
 * @param f The hydration function, which takes a DOM node as its input parameter and returns the new version of the DOM node.
 * @returns undefined
 */
let hydrate: (Dom.element, Dom.element => Dom.element) => unit

module Child: {
  /**
  * Represents a child element with a name and value.
  */
  type c<'a> = {
    "NAME": string,
    "VAL": 'a
  }

  // Helper childFrom functions to reduce the boileplate
  // and convert the types of child elements
  let text: string => c<'a>
  let number: float => c<'a>
  let integer: int => c<'a>
  let dom: Dom.element => c<'a>
  let boolean: bool => c<'a>
  let stateChild: state<'a> => c<'a>
  let nil: Null.t<'a> => c<'a>
}

module Tags: {
  /**
   * Represents the namespace of an element.
   */
  type namespace =
    | Html
    | Svg
    | MathMl
    | Custom(string)

  /**
   * Creates a DOM element with optional properties and children.
   * @param namespace The namespace of the element (e.g., `Html`, `Svg`).
   * @param tagName The name of the tag (e.g., `"div"`, `"span"`).
   * @param properties An object containing attributes for the element.
   * @param children An array of children to append to the element.
   * @returns The created DOM element.
   */
  let createTag: (
    ~namespace: namespace=?,
    ~tagName: string,
    ~properties: {..}=?,
    ~children: array<Child.c<'a>>=?,
  ) => Dom.element
}

module Dom: {
  type domBuilder = {
    tag: string,
    namespace: Tags.namespace,
    props?: {..},
    children?: array<Child.c<'a>>,
  }

  let createElement: (string, ~namespace: Tags.namespace=?) => domBuilder
  let withProps: (domBuilder, option<{..}>) => domBuilder
  let addChild: (domBuilder, Child.c<'a>) => domBuilder
  let build: domBuilder => Dom.element
}