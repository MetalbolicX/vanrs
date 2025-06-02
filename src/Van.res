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

module Child = {
  /**
   * Represents a child element with a name and value.
   * @param 'a The type of the value.
   */
  type t<'a> =
    | Text(string)
    | Number(float)
    | Int(int)
    | Dom(Dom.element)
    | Boolean(bool)
    | State(state<'a>)
    | Nil(Null.t<'a>)

  /**
   * Represents the child f the polyvariant type of th child elment.
    */
  type child<'a> = {"NAME": string, "VAL": 'a}

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
  ] => child<'a> = "%identity"

  /**
   * Unwraps the value from a child element.
   * @param child The child element to unwrap.
   * @returns The unwrapped value.
   */
  let unwrapChild: child<'a> => 'a = child => child["VAL"]

  /**
   * Casts a child element to the appropriate type.
   * @param child The child element to cast.
   * @returns A child element of type `child<'a>`.
   */
  let castChild: t<'a> => child<'a> = child => {
    switch child {
    | Text(str) => childFrom(#Text(str))
    | Number(n) => childFrom(#Number(n))
    | Int(i) => childFrom(#Int(i))
    | Dom(el) => childFrom(#Dom(el))
    | Boolean(b) => childFrom(#Boolean(b))
    | State(st) => childFrom(#State(st))
    | Nil(n) => childFrom(#Nil(n))
    }
  }
}

/**
 * Adds child DOM elements or other valid children to a parent DOM element.
 * @param parent The parent DOM element.
 * @param children A variadic list of children to add.
 * @returns The parent DOM element for chaining.
 */
@module("vanjs-core") @scope("default") @variadic
external addVan: (Dom.element, array<'a>) => Dom.element = "add"

let add: (Dom.element, array<Child.t<'a>>) => Dom.element = (parent, children) => {
  let parsedChildren = children->Array.map(c => c->Child.castChild)->Array.map(c => c->Child.unwrapChild)
  parent->addVan(parsedChildren)
}

/**
 * Hydrates the SSR component dom with the hydration function f.
 * @param dom The root DOM node of the SSR component we want to hydrate.
 * @param f The hydration function, which takes a DOM node as its input parameter and returns the new version of the DOM node.
 * @returns undefined
 */
@module("vanjs-core") @scope("default")
external hydrate: (Dom.element, Dom.element => Dom.element) => unit = "hydrate"

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
   * Represents a builder for creating DOM elements.
   * @param 'p The type of the attributes and properties object.
   * @param 'a The type of the children elements.
   */
  type t<'p, 'a> = {
    tag: string,
    namespace: namespace,
    attrs?: 'p,
    children?: array<Child.t<'a>>,
  }


  /**
   * Retrieves the `tags` proxy object for the specified namespace.
   * @param namespace The namespace string or unit for default HTML namespace.
   * @returns A proxy object for creating elements in the specified namespace.
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
    ~children: array<Child.t<'a>>=?,
  ) => Dom.element = (~namespace as ns=Html, ~tagName, ~attributes as attrs=Object.make(), ~children=[]) => {
    let namespaceProxy = switch resolveNamespace(ns) {
    | Some(n) => tags(#Str(n))
    | None => tags(#Unit())
    }

    %raw(`(proxy, tagName, attrs, children) => proxy[tagName](attrs, ...children)`)(
      namespaceProxy,
      tagName,
      attrs,
      children->Array.map(c => Child.castChild(c))-> Array.map(c => c->Child.unwrapChild)
    )
  }

  /**
  * Creates a new DOM element builder.
  * @param string The tag name of the element to create.
  * @param namespace The namespace of the element (optional).
  * @returns A new element builder instance with the specified tag and namespace.
   */
  let make: (string, ~namespace: namespace=?) => t<'p, 'a> = (
    tag,
    ~namespace=Html,
  ) => {tag, namespace}

  /**
   * Adds a property to the new element builder.
   * @param builder The current domBuilder instance.
   * @param prop The property to add.
   * @returns A new domBuilder instance with the added property.
   */
  let attr: (t<'oldProps, 'a>, 'newProps) => t<'newProps, 'a> = (
    builder,
    attrs,
  ) => {...builder, attrs}

  /**
   * Adds a child to the new element builder.
   * @param builder The current domBuilder instance.
   * @param child The child element to add.
   * @returns A new element builder instance with the added child.
   */
  let append: (t<'p, 'a>, Child.t<'a>) => t<'p, 'a> = (builder, child) => {
    ...builder,
    children: switch builder.children {
      | Some(children) => [...children, child]
      | None => [child]
    }
  }

  /**
   * Adds multiple children to the new element builder.
   * @param builder The current domBuilder instance.
   * @param children An array of child elements to add.
   * @returns A new element builder instance with the added children.
   */
  let appendChildren: (t<'p, 'a>, array<Child.t<'a>>) => t<'p, 'a> = (builder, children) =>
    children->Array.reduce(builder, (list, child) => append(list, child))

  /**
   * Builds the DOM element from the current builder state.
   * @param builder The current domBuilder instance.
   * @returns A DOM element created from the builder's properties and children.
   */
  let build: t<'p, 'a> => Dom.element = builder =>
    createTag(
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