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

// Console.log(Van.Tags.createTag(~tagName="span"))
// Console.log(Van.Tags.createTag(Svg, "circle"))
Van.add(
  root,
  Van.Tags.createTag(
    ~namespace=Svg,
    ~tagName="circle",
    ~properties={"class": "test", "id": "special", "cx": 50, "cy": 50, "r": 40},
  ),
)
// Van.add(root, Van.Tags.createTag(~tagName="span", ~properties={"class": "test", "id": "special"}))
