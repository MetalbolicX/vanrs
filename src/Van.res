type dom = Dom.element

@val external document: Dom.document = "document"
@send external createTextNode: (Dom.document, string) => dom = "createTextNode"

@module("vanjs-core") @scope("default")
external add: (dom, dom) => unit = "add"

@module("vanjs-core") @scope("default")
external state: 'a => {"val": 'a, "set": ('a => 'a) => unit} = "state"

@module("vanjs-core") @scope("default")
external derive: ('a => 'b, 'a) => 'b = "derive"

module Tags = {
  // Namespace type
  type namespace =
    | Html
    | Svg
    | MathMl
    | Custom(string)

  type rec child =
    | DomNode(dom)
    | Text(string)
    | Number(float)
    | Boolean(bool)
    | Null
    | None
  // | StateValue<'a>('a)
  // | StateDerived<'a>('a => 'a)
  // | Children(array<child>)

  // Type for tags proxy
  type tagsProxy

  // External binding to van.tags without arguments (default HTML namespace)
  @module("vanjs-core") @scope("default")
  external tags: unit => tagsProxy = "tags"

  // External binding to van.tags with namespace argument
  @module("vanjs-core") @scope("default")
  external tagsNs: string => tagsProxy = "tags"

  // Resolve namespace to its string representation
  let resolveNamespace: namespace => option<string> = namespace => {
    switch namespace {
    | Html => None
    | Svg => Some("http://www.w3.org/2000/svg")
    | MathMl => Some("http://www.w3.org/1998/Math/MathML")
    | Custom(ns) => Some(ns)
    }
  }

  let normalizedChild: child => dom = child => {
    switch child {
    | DomNode(node) => node
    | Text(str) => document->createTextNode(str)
    | Number(num) => document->createTextNode(Float.toString(num))
    | Boolean(bool) => document->createTextNode(string_of_bool(bool))
    | None | Null => document->createTextNode("")
    }
  }

  let normalizedChildren: array<child> => array<dom> = children =>
    children
    ->Array.filter(child =>
      switch child {
      | Text(str) when String.equal(str, "") => false
      | Null | None => false
      | _ => true
      }
    )
    ->Array.map(normalizedChild)

  // Create a tag function with optional namespace
  let createTag: (
    ~namespace: namespace=?,
    ~tagName: string,
    ~properties: {..}=?,
    ~children: array<child>=?,
  ) => dom = (
    ~namespace as ns=Html,
    ~tagName,
    ~properties as props=Js.Obj.empty(),
    ~children=[],
  ) => {
    let proxy = switch resolveNamespace(ns) {
    | Some(n) => tagsNs(n)
    | None => tags()
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
