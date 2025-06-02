# API Index Reference

VanJS provides a comprehensive API for building reactive applications. Below is an index of those APIs for more details check the [VanJS documentation](https://vanjs.org/tutorial).

## DOM Composition and Manipulation

### `Van.add`

**Description:**
Mutates DOM by appending 0 or more child nodes to it Returns a DOM element for possibly further chaining.

**Signature:**
```txt
let add: (Dom.Element, Child.t<'a>) => Dom.Element
```

Parameters:
- `parent: Dom.element`: The parent element to which children will be added.
- `child: Child.t<'a>`: The child to be added.

#### `Child.t<'a>` (Variant)

`Child.t<'a>` is a variant type representing all node types that can be added as children in VanJS. This allows you to pass a wide range of values as children, making the API flexible and ergonomic.

**Variant cases:**
- `Text(string)` — A text node.
- `Number(float)` — A floating-point number node.
- `Int(int)` — An integer node.
- `Dom(Dom.element)` — A raw DOM element.
- `Boolean(bool)` — A boolean value (typically rendered as text).
- `State(state<'a>)` — A reactive state value; the DOM will update when the state changes.
- `Nil(Null.t<'a>)` — Represents a null or empty value (no node will be rendered).

This design allows you to pass strings, numbers, booleans, DOM elements, and reactive state directly as children, and VanJS will handle them appropriately.

**Example:**
```txt
Van.add(parent, Text("Hello, World!"))->ignore
```

!> Futher information of the `Van.add` can be found in the [VanJS documentation](https://vanjs.org/tutorial#api-add).

### `Van.Dom`

`Van.Dom` is a wrapper module that works around `van.tags` API to create new DOM elements, set its attributes and add other child or children element. It uses the builder design pattern to provide a fluent API for building DOM elements.

#### `Van.Dom.createElement`

**Description:**
Creates a new domBuilder with the specified tag and optional namespace.

**Signature:**
```txt
let createElement: (string, ~namespace: Tags.namespace=?) => domBuilder<{..}, 'a>
```

## State

## State Binding