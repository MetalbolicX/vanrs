/**
 * Adds child DOM elements or other valid children to a parent DOM element.
 * @param parent The parent DOM element.
 * @param children A variadic list of children to add.
 * @returns The parent DOM element for chaining.
 */
@module("vanjs-core") @scope("default")
external add: (Dom.element, 'a) => Dom.element = "add"

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
 * @param deriveFn A function that derives a value based on other states.
 * @returns A derived state object that updates automatically.
 */
@module("vanjs-core") @scope("default")
external derive: (unit => 'a) => state<'a> = "derive"

/**
 * Hydrates the SSR component dom with the hydration function f.
 * @param dom The root DOM node of the SSR component we want to hydrate.
 * @param f The hydration function, which takes a DOM node as its input parameter and returns the new version of the DOM node.
 * @returns undefined
 */
@module("vanjs-core") @scope("default")
external hydrate: (Dom.element, Dom.element => Dom.element) => unit = "hydrate"

module Child = {
  /**
   * Represents a child element with a name and value.
    */
  type c<'a> = {"NAME": string, "VAL": 'a}

  /**
   * Converts various types to a child element.
    * @param value The value to convert (string, number, DOM element, boolean, or state).
    * @returns A child element.
    */
  external childFrom: @unwrap
  [
    | #Text(string)
    | #Number(float)
    | #Int(int)
    | #Dom(Dom.element)
    | #Boolean(bool)
    | #State(state<'a>)
    | #Nil(Null.t<'a>)
  ] => c<'a> = "%identity"

  /**
   * Creates a child element from a string.
   * @param str The string value to convert.
   * @returns A child element representing the text.
   */
  let toText: string => c<'a> = str => childFrom(#Text(str))

  /**
   * Creates a child element from a float number.
   * @param n The float number to convert.
   * @returns A child element representing the number.
   */
  let toNumber: float => c<'a> = n => childFrom(#Number(n))

  /**
   * Creates a child element from an integer.
   * @param i The integer to convert.
   * @returns A child element representing the integer.
   */
  let toInt: int => c<'a> = i => childFrom(#Int(i))

  /**
   * Creates a child element from a DOM element.
   * @param el The DOM element to convert.
   * @returns A child element representing the DOM element.
   */
  let toDom: Dom.element => c<'a> = el => childFrom(#Dom(el))

  /**
   * Creates a child element from a boolean value.
   * @param b The boolean value to convert.
   * @returns A child element representing the boolean.
   */
  let toBool: bool => c<'a> = b => childFrom(#Boolean(b))

  /**
   * Creates a child element from a state object.
   * @param st The state object to convert.
   * @returns A child element representing the state.
   */
  let toState: state<'a> => c<'a> = st => childFrom(#State(st))

  /**
   * Creates a child element from a null value.
   * @param n The null value to convert.
   * @returns A child element representing the null value.
   */
  let toNull: Null.t<'a> => c<'a> = n => childFrom(#Nil(n))
}

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
   * Retrieves the `tags` proxy object for the specified namespace.
   * @param namespace The namespace string or unit for default HTML namespace.
   * @returns A proxy object for creating elements in the specified namespace.
   */
  @module("vanjs-core") @scope("default")
  external tags: @unwrap [#Str(string) | #Unit(unit)] => 'a = "tags"

  /**
   * Unwraps the value from a child element.
   * @param child The child element to unwrap.
   * @returns The unwrapped value.
   */
  let unwrapChild: Child.c<'a> => 'a = child => child["VAL"]

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
    ~attributes: {..}=?,
    ~children: array<Child.c<'a>>=?,
  ) => Dom.element = (~namespace as ns=Html, ~tagName, ~attributes as attrs=Object.make(), ~children=[]) => {
    let namespaceProxy = switch resolveNamespace(ns) {
    | Some(n) => tags(#Str(n))
    | None => tags(#Unit())
    }

    %raw(`(proxy, tagName, attrs, children) => proxy[tagName](attrs, ...children)`)(
      namespaceProxy,
      tagName,
      attrs,
      children->Array.map(unwrapChild),
    )
  }
}
module Dom = {
  /**
   * Represents a builder for creating DOM elements.
   * @param 'p The type of the attributes and properties object.
   * @param 'a The type of the children elements.
   */
  type domBuilder<'p, 'a> = {
    tag: string,
    namespace: Tags.namespace,
    attrs?: 'p,
    children?: array<Child.c<'a>>,
  }

  /**
   * Creates a new domBuilder with the specified tag and optional namespace.
   * @param tag The HTML tag name for the element.
   * @param namespace The namespace for the element (default is HTML).
   * @returns A new domBuilder instance.
   */
  let createElement: (string, ~namespace: Tags.namespace=?) => domBuilder<'p, 'a> = (
    tag,
    ~namespace=Tags.Html,
  ) => {tag, namespace}

  /**
   * Adds or updates properties and attributes of a domBuilder.
   * @param builder The current domBuilder instance.
   * @param props The new properties to add or update.
   * @returns A new domBuilder instance with updated properties.
   */
  let setAttrs: (domBuilder<'oldProps, 'a>, 'newProps) => domBuilder<'newProps, 'a> = (
    builder,
    attrs,
  ) => {...builder, attrs}

  /**
   * Adds a single child to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param child The child element to add.
   * @returns A new domBuilder instance with the added child.
   */
  let addChild: (domBuilder<'p, 'a>, Child.c<'a>) => domBuilder<'p, 'a> = (builder, child) => {
    ...builder,
    children: switch builder.children {
      | Some(children) => [...children, child]
      | None => [child]
    }
  }

  /**
   * Adds multiple children to a domBuilder.
   * @param builder The current domBuilder instance.
   * @param children An array of child elements to add.
   * @returns A new domBuilder instance with all children added.
   */
  let addChildren: (domBuilder<'p, 'a>, array<Child.c<'a>>) => domBuilder<'p, 'a> = (builder, children) =>
    children->Array.reduce(builder, (acc, child) => addChild(acc, child))

  /**
   * Builds the final DOM element from a domBuilder.
   * @param builder The domBuilder instance to build from.
   * @returns The constructed DOM element.
   */
  let build: domBuilder<'p, 'a> => Dom.element = builder =>
    Tags.createTag(
      ~tagName=builder.tag,
      ~namespace=builder.namespace,
      ~children=switch builder.children {
        | Some(children) => [...children]
        | None => []
      },
      ~attributes=switch builder.attrs {
        | Some(attrs) => attrs
        | None => Object.make()
      }
    )
}