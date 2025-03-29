type dom = Dom.element

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
    // | StateValue('a)
    // | StateDerived('a => 'b)
    | Children(array<child>)

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

  // Create a tag function with optional namespace
  let createTag: (
    ~namespace: namespace=?,
    ~tagName: string,
    // ~children: array<'a>=?,
    ~properties: {..}=?,
  ) => dom = (
    ~namespace as ns=Html,
    ~tagName,
    // ~children=None,
    ~properties as props=Js.Obj.empty(),
  ) => {
    let proxy = switch resolveNamespace(ns) {
    | Some(n) => tagsNs(n)
    | None => tags()
    }
    %raw(`(tagsProxy, tagName) => tagsProxy[tagName]`)(proxy, tagName)(props)
  }
}
