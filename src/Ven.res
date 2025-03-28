// // (* Van.res - ReScript bindings for VanJS *)

// type state<'a>
// type dom
// type props
// type children
// type namespace = Html | Svg | MathMl | Custom(string)

// type tagName = string

// // (* State creation and manipulation *)
// @module("vanjs-core")
// external state: 'a => state<'a> = "state"

// @module("vanjs-core")
// external derive: (('a) => 'b, option<state<'b>>, option<dom>) => state<'b> = "derive"

// @module("vanjs-core")
// external add: (dom, ~children: array<'a>) => dom = "add"

// // (* Overloaded add function to match VanJS flexible children handling *)
// let addChildren = (dom: dom, ~children: array<'a>) => add(dom, ~children)

// // (* Namespace resolution *)
// let resolveNamespace = (namespace: namespace): option<string> => {
//   switch namespace {
//   | Html => None
//   | Svg => Some("http://www.w3.org/2000/svg")
//   | MathMl => Some("http://www.w3.org/1998/Math/MathML")
//   | Custom(ns) => Some(ns)
//   }
// }

// // (* Dynamic Tags Proxy *)
// module Tags = {
//   type t

//   // (* Raw external to access van.tags *)
//   @module("vanjs-core") external tags: t = "tags"

//   // (* Opaque type for tag functions to maintain type safety *)
//   type tagFunc =
//     | Props(props: Js.Dict.t<'a>)
//     | NoProps

//   // (* Bind to the proxy-based tag creation *)
//   @send external tagCreate: (
//     t,
//     string,
//     ~props: Js.Dict.t<'a>=?,
//     ~children: array<'b>=?
//   ) => dom = "call"

//   // (* Generic tag creator that mimics VanJS API *)
//   let createElement = (
//     tagName: string,
//     ~props: option<Js.Dict.t<'a>>=[],
//     ~children: option<array<'b>>=[],
//     ()
//   ) => tagCreate(tags, tagName, ~props?, ~children?)

//   // (* Helper to create props dictionary *)
//   let makeProps = Js.Dict.fromArray

//   // (* Helper to handle event handlers *)
//   let onEvent = (eventName: string, handler: 'event => unit) => {
//     let key = "on" ++ String.toLowerCase(eventName)
//     Js.Dict.fromArray([(key, handler)])
//   }
// }


// // (* State Utility Functions *)
// let stateGet: state<'a> => 'a = %raw(`
//   function(state) {
//     return state.val;
//   }
// `)

// let stateSet: (state<'a>, 'a) => unit = %raw(`
//   function(state, value) {
//     state.val = value;
//   }
// `)