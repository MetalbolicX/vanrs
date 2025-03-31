type dom = Dom.element

/**
 * Adds child DOM elements to a parent DOM element.
 *
 * @param parent The parent DOM element.
 * @param children An array of child DOM elements to add.
 */
let add: (dom, array<dom>) => unit

/**
 * Creates a new state object.
 *
 * @param initialValue The initial value of the state.
 * @returns A state object with a mutable `val` field.
 */
type state<'a> = {mutable val: 'a}
let state: 'a => state<'a>

/**
 * Creates a derived state object based on a derivation function.
 *
 * @param f A function that derives a value based on other states.
 * @returns A derived state object that updates automatically.
 */
let derive: (unit => 'a) => state<'a>

/**
 * Module for creating DOM elements with optional namespaces.
 */
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
   * Represents a valid child for a DOM element.
   */
  type child =
    | DomNode(dom)
    | Text(string)
    | Number(float)
    | Boolean(bool)
    | Null
    | None
    | State(state<string>)
    | Derived(state<string>)

  /**
   * Creates a DOM element with optional properties and children.
   *
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
    ~children: array<child>=?,
  ) => dom
}
