@val external document: Dom.document = "document"

@send @return(nullable)
external getElementById: (Dom.document, string) => option<Dom.element> = "getElementById"

@send external createElement: (Dom.document, string) => Dom.element = "createElement"

let root = switch document->getElementById("root") {
| Some(element) => element
| None => Js.Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget = "target"
@get external getInputValue: Dom.eventTarget => string = "value"

let deriveState: unit => Van.dom = () => {
  let vanText = Van.state("VanJs")
  let length = Van.derive(() => vanText.val->String.length)
  Van.Tags.createTag(
    ~tagName="p",
    ~children=[
      Van.Tags.Text(`The length of the text is: ${length.val->Int.toString}`),
      Van.Tags.DomNode(
        Van.Tags.createTag(
          ~tagName="input",
          ~properties={
            "type": "text",
            "value": vanText,
            "oninput": (event: Dom.event) => {
              vanText.val = event->getEventTarget->getInputValue
              Console.log2(length, vanText)
            },
          },
          ~children=[Van.Tags.Text("Input")],
        )
      ),
      // Van.Tags.Derived(length.val->Int.toString)
    ],
  )
}

Van.add(root, [deriveState()])
