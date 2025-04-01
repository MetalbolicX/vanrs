type dom = Dom.element

/**
 * Represents the global `document` object.
 */
@val
external document: Dom.document = "document"

/**
 * Creates a text node in the DOM.
 * @param document The global `document` object.
 * @param text The text content for the node.
 * @returns A DOM text node.
 */
@send
external createTextNode: (Dom.document, string) => dom = "createTextNode"

/**
 * Adds child DOM elements to a parent DOM element.
 * @param parent The parent DOM element.
 * @param children An array of child DOM elements to add.
 */
@module("vanjs-core") @scope("default")
external add: (dom, array<dom>) => unit = "add"

/**
 * Represents a state object with a mutable `val` field.
 */
type state<'a> = {mutable val: 'a}

/**
 * Creates a new state object.
 * @param initialValue The initial value of the state.
 * @returns A state object with a mutable `val` field.
 */
@module("vanjs-core") @scope("default")
external state: 'a => state<'a> = "state"

/**
 * Creates a derived state object based on a derivation function.
 * @param f A function that derives a value based on other states.
 * @returns A derived state object that updates automatically.
 */
@module("vanjs-core") @scope("default")
external derive: (unit => 'a) => state<'a> = "derive"

module Tags = {
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
    | DomNode(dom) // A DOM node
    | Text(string) // A plain string
    | Number(float) // A number
    | Boolean(bool) // A boolean
    | Null // Null value
    | None // None value
    | State(state<string>) // A state object
    | Derived(state<string>) // A derived state object

  /**
   * Retrieves the `tags` proxy object for the default HTML namespace.
   * @returns A proxy object for creating HTML elements.
   */
  @module("vanjs-core") @scope("default")
  external tags: @unwrap [#Str(string) | #Unit(unit)] => 'a = "tags"

  /**
   * Resolves the namespace to its string representation.
   * @param namespace The namespace type (e.g., `Html`, `Svg`).
   * @returns An optional string representing the namespace URI.
   */
  let resolveNamespace: namespace => option<string> = namespace => {
    switch namespace {
    | Html => None
    | Svg => Some("http://www.w3.org/2000/svg")
    | MathMl => Some("http://www.w3.org/1998/Math/MathML")
    | Custom(ns) => Some(ns)
    }
  }

  /**
   * Normalizes a `child` into a DOM node.
   * @param child The child to normalize.
   * @returns A DOM node representing the child.
   */
  let normalizedChild: child => dom = child => {
    switch child {
    | DomNode(node) => node
    | Text(str) => document->createTextNode(str)
    | Number(num) => document->createTextNode(Float.toString(num))
    | Boolean(bl) => document->createTextNode(string_of_bool(bl))
    | State(st) => document->createTextNode(st.val->String.make)
    | Derived(dv) => document->createTextNode(dv.val->String.make)
    | None | Null => document->createTextNode("")
    }
  }

  /**
   * Filters out invalid children (e.g., empty strings, `Null`, `None`).
   * @param child The child to check.
   * @returns `true` if the child is valid, `false` otherwise.
   */
  let removeChildInput: child => bool = child =>
    switch child {
    | Text(str) if str->String.trim->String.equal("") => false
    | Null | None => false
    | _ => true
    }

  /**
   * Normalizes an array of children into an array of DOM nodes.
   * @param children The array of children to normalize.
   * @returns An array of DOM nodes.
   */
  let normalizedChildren: array<child> => array<dom> = children =>
    children
    ->Array.filter(removeChildInput)
    ->Array.map(normalizedChild)

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
    ~children: array<child>=?,
  ) => dom = (
    ~namespace as ns=Html,
    ~tagName,
    ~properties as props=Object.make(),
    ~children=[],
  ) => {
    let proxy = switch resolveNamespace(ns) {
    | Some(n) => tags(#Str(n))
    | None => tags(#Unit())
    }

    let normChildren = normalizedChildren(children)
    %raw(`(proxy, tagName, props, children) => proxy[tagName](props, ...children)`)(
      proxy,
      tagName,
      props,
      normChildren,
    )
  }
}
