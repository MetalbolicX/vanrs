type dom = Dom.element

@val external document: Dom.document = "document"
@send external createTextNode: (Dom.document, string) => dom = "createTextNode"

@module("vanjs-core") @scope("default")
external add: (dom, array<dom>) => unit = "add"

type state<'a> = {
  mutable val: 'a,
}

@module("vanjs-core") @scope("default")
external state: 'a => state<'a> = "state"

@module("vanjs-core") @scope("default")
external derive: (() => 'a) => state<'a> = "derive"

module Tags = {
  // Namespace type
  type namespace =
    | Html
    | Svg
    | MathMl
    | Custom(string)

  type child =
    | DomNode(dom)
    | Text(string)
    | Number(float)
    | Boolean(bool)
    | Null
    | None
    | State(state<string>)
    | Derived(state<string>)

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
    | Boolean(bl) => document->createTextNode(string_of_bool(bl))
    | State(st) => document->createTextNode(st.val->String.make)
    | Derived(dv) => document->createTextNode(dv.val->String.make)
    | None | Null => document->createTextNode("")
    }
  }

  let removeChildInput: child => bool = child =>
    switch child {
    | Text(str) when str->String.trim->String.equal("") => false
    | Null | None => false
    | _ => true
    }

  let normalizedChildren: array<child> => array<dom> = children =>
    children
    ->Array.filter(removeChildInput)
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
    ~properties as props=Object.make(),
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
