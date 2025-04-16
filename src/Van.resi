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
   * This type is used internally by VanJS to manage child elements.
   */
  type c<'a> = {
    "NAME": string,
    "VAL": 'a
  }

  /**
   * Converts a string to a child element.
   * @param text The string to convert.
   * @returns A child element representing the text.
   */
  let toText: string => c<'a>

  /**
   * Converts a float to a child element.
   * @param num The float number to convert.
   * @returns A child element representing the number.
   */
  let toNumber: float => c<'a>

  /**
   * Converts an integer to a child element.
   * @param num The integer to convert.
   * @returns A child element representing the integer.
   */
  let toInt: int => c<'a>

  /**
   * Converts a DOM element to a child element.
   * @param element The DOM element to convert.
   * @returns A child element representing the DOM element.
   */
  let toDom: Dom.element => c<'a>

  /**
   * Converts a boolean to a child element.
   * @param value The boolean value to convert.
   * @returns A child element representing the boolean.
   */
  let toBool: bool => c<'a>

  /**
   * Converts a state object to a child element.
   * @param stateObj The state object to convert.
   * @returns A child element representing the state.
   */
  let toState: state<'a> => c<'a>

  /**
   * Converts a null value to a child element.
   * @param nullValue The null value to convert.
   * @returns A child element representing the null value.
   */
  let toNull: Null.t<'a> => c<'a>
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
  /**
   * Represents a builder for creating DOM elements.
   * @param 'p The type of the properties object.
   * @param 'a The type of the children elements.
   */
  type domBuilder<'p, 'a> = {
    tag: string,
    namespace: Tags.namespace,
    props: 'p,
    children: array<Child.c<'a>>,
  }

  /**
   * Creates a new domBuilder with the specified tag and optional namespace.
   * @param tag The HTML tag name for the element.
   * @param namespace The namespace for the element (default is HTML).
   * @returns A new domBuilder instance with empty properties.
   */
  let createElement: (string, ~namespace: Tags.namespace=?) => domBuilder<{..}, 'a>

  /**
   * Adds or updates properties of a domBuilder.
   * @param builder The current domBuilder instance.
   * @param props The new properties to add or update.
   * @returns A new domBuilder instance with updated properties.
   */
  let withProps: (domBuilder<'oldProps, 'a>, 'newProps) => domBuilder<'newProps, 'a>

  /**
   * Adds a single child to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param child The child element to add.
   * @returns A new domBuilder instance with the added child.
   */
  let addChild: (domBuilder<'p, 'a>, Child.c<'a>) => domBuilder<'p, 'a>

  /**
   * Adds multiple children to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param children An array of child elements to add.
   * @returns A new domBuilder instance with all children added.
   */
  let addChildren: (domBuilder<'p, 'a>, array<Child.c<'a>>) => domBuilder<'p, 'a>

  /**
   * Builds the final DOM element from a domBuilder.
   * @param builder The domBuilder instance to build from.
   * @returns The constructed DOM element.
   */
  let build: domBuilder<{..}, 'a> => Dom.element
}