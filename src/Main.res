@val external document: Dom.document = "document"

@send @return(nullable)
external getElementById: (Dom.document, string) => option<Dom.element> = "getElementById"

@send external createElement: (Dom.document, string) => Dom.element = "createElement"

let root = switch document->getElementById("root") {
| Some(element) => element
| None => Js.Exn.raiseError("Root element not found")
}

Van.add(
  root,
  [
    Van.Tags.createTag(
      ~properties={
        "class": "test",
        "id": "special",
        "onclick": _ => Console.log("Hello clicked!"),
      },
      ~tagName="button",
      ~children=[
        Van.Tags.Text("Give me a click!"),
        // Van.Tags.DomNode(Van.Tags.createTag(~tagName="span", ~children=[Van.Tags.Text("world!")])),
      ],
    ),
    document->createElement("span")
  ],
)
