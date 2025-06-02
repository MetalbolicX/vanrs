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
let add: (Dom.element, array<Child.t<'a>>) => Dom.element

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

  /**
  * Represents a builder for creating DOM elements.
  * @param 'p The type of the properties object.
  * @param 'a The type of the children elements.
   */
  type t<'p, 'a> = {
    tag: string,
    namespace: namespace,
    attrs?: 'p,
    children?: array<Child.t<'a>>
  }

  /**
  * Creates a new DOM element builder.
  * @param string The tag name of the element to create.
  * @param namespace The namespace of the element (optional).
  * @returns A new element builder instance with the specified tag and namespace.
   */
  let make: (string, ~namespace: namespace=?) => t<{..}, 'a>

  /**
   * Adds a property to the new element builder.
   * @param builder The current domBuilder instance.
   * @param prop The property to add.
   * @returns A new domBuilder instance with the added property.
   */
  let attr: (t<'oldProps, 'a>, 'newProps) => t<'newProps, 'a>

  /**
   * Adds a child to the new element builder.
   * @param builder The current domBuilder instance.
   * @param child The child element to add.
   * @returns A new element builder instance with the added child.
   */
  let append: (t<'p, 'a>, Child.t<'a>) => t<'p, 'a>

  /**
   * Adds multiple children to the new element builder.
   * @param builder The current domBuilder instance.
   * @param children An array of child elements to add.
   * @returns A new element builder instance with the added children.
   */
  let appendChildren: (t<'p, 'a>, array<Child.t<'a>>) => t<'p, 'a>

  /**
   * Builds the DOM element from the current builder state.
   * @param builder The current domBuilder instance.
   * @returns A DOM element created from the builder's properties and children.
   */
  let build: t<{..}, 'a> => Dom.element
}