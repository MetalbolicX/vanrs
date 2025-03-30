@val external document: Dom.document = "document"

@send @return(nullable)
external getElementById: (Dom.document, string) => option<Dom.element> = "getElementById"

@send external createElement: (Dom.document, string) => Dom.element = "createElement"

let root = switch document->getElementById("root") {
| Some(element) => element
| None => Js.Exn.raiseError("Root element not found")
}

// let counter = state(0)
// Console.log(derive(() => counter.val + 1))

// let increment = () => {
//   counter.set(prev => prev + 1)
// }

// let app = div(
//   ~children=[
//     text(`Count: ${counter.val->Int.toString}`),
//     button(~onclick=increment, ~children=[text("Increment")], ())
//   ],
//   ()
// )

Van.add(
  root,
  Van.Tags.createTag(
    ~properties={
      "class": "test",
      "id": "special",
      "onclick": _ => Console.log("Hello clicked!"),
    },
    ~tagName="button",
    ~children=[
      Van.Tags.Text("Click me!"),
      // Van.Tags.DomNode(Van.Tags.createTag(~tagName="span", ~children=[Van.Tags.Text("world!")])),
    ],
  ),
)
