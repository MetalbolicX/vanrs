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

module Child: {
  /**
   * Represents a child element with a name and value.
   * This type is used internally by VanJS to manage child elements.
   */
  type t<'a> =
    | Text(string)
    | Number(float)
    | Int(int)
    | Dom(Dom.element)
    | Boolean(bool)
    | State(state<'a>)
    | Nil(Null.t<'a>)
}

/**
 * Adds a child element to a DOM element using the VanJS library.
 * @param dom The DOM element to which the child will be added.
  * @param child The child element to add, which can be a text, number, DOM element, boolean, state, or null.
 */
let add: (Dom.element, Child.t<'a>) => Dom.element

/**
 * Hydrates the SSR component dom with the hydration function f.
 * @param dom The root DOM node of the SSR component we want to hydrate.
 * @param f The hydration function, which takes a DOM node as its input parameter and returns the new version of the DOM node.
 * @returns undefined
 */
let hydrate: (Dom.element, Dom.element => Dom.element) => unit

module Tags: {
  /**
   * Represents the namespace of an element.
   */
  type namespace =
    | Html
    | Svg
    | MathMl
    | Custom(string)
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
    attrs?: 'p,
    children?: array<Child.t<'a>>,
  }

  /**
   * Creates a new domBuilder with the specified tag and optional namespace.
   * @param tag The HTML tag name for the element.
   * @param namespace The namespace for the element (default is HTML).
   * @returns A new domBuilder instance with empty properties.
   */
  let createElement: (string, ~namespace: Tags.namespace=?) => domBuilder<{..}, 'a>

  /**
   * Adds or updates properties and attribures of a domBuilder.
   * @param builder The current domBuilder instance.
   * @param attrs The new properties or attributes to add or update.
   * @returns A new domBuilder instance with updated properties.
   */
  let attr: (domBuilder<'oldProps, 'a>, 'newProps) => domBuilder<'newProps, 'a>

  /**
   * Adds a single child to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param child The child element to add.
   * @returns A new domBuilder instance with the added child.
   */
  let append: (domBuilder<'p, 'a>, Child.t<'a>) => domBuilder<'p, 'a>

  /**
   * Adds multiple children to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param children An array of child elements to add.
   * @returns A new domBuilder instance with all children added.
   */
  let appendChildren: (domBuilder<'p, 'a>, array<Child.t<'a>>) => domBuilder<'p, 'a>

  /**
   * Builds the final DOM element from a domBuilder.
   * @param builder The domBuilder instance to build from.
   * @returns The constructed DOM element.
   */
  let build: domBuilder<{..}, 'a> => Dom.element
}