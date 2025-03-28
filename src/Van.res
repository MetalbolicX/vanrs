type dom = Dom.element

@module("vanjs-core") @scope("default")
external add: (dom, dom) => unit = "add"

@module("vanjs-core") @scope("default")
external state: 'a => {"val": 'a, "set": ('a => 'a) => unit} = "state"

@module("vanjs-core") @scope("default")
external derive: ('a => 'b, 'a) => 'b = "derive"

module Tags = {
  type namespace =
    | Html
    | Svg
    | MathMl
    | Custom(string)

  // Type to represent the tags proxy object
  type tagsProxy

  // External binding to van.tags without arguments (default HTML namespace)
  @module("vanjs-core") @scope("default")
  external tags: unit => tagsProxy = "tags"

  // External binding to van.tags with namespace argument
  @module("vanjs-core") @scope("default")
  external tagsWithNamespace: string => tagsProxy = "tags"

  // Resolve namespace to its string representation
  let resolveNamespace: namespace => option<string> = ns => {
    switch ns {
    | Html => None
    | Svg => Some("http://www.w3.org/2000/svg")
    | MathMl => Some("http://www.w3.org/1998/Math/MathML")
    | Custom(n) => Some(n)
    }
  }

  // Create a tag function with optional namespace
  let createTag: (~namespace: namespace=?, ~tagName: string) => dom = (
    ~namespace as ns=Html,
    ~tagName,
  ) => {
    let proxy = switch resolveNamespace(ns) {
    | Some(n) => tagsWithNamespace(n)
    | None => tags()
    }

    %raw(`
      function(tagsProxy, tagName) {
        return tagsProxy[tagName]
      }
    `)(proxy, tagName)()
  }
}
