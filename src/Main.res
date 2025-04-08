@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Js.Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget = "target"
@get external getInputValue: Dom.eventTarget => string = "value"
// @get external getEventTarget: Dom.event => Dom.eventTarget_like<Dom.htmlInputElement> = "target"
// @get external getInputValue: Dom.event_like<Dom.htmlInputElement> => string = "value"

let deriveState = () => {
  // let vanText = Van.state("VanJs")
  // let length = Van.derive(() => vanText.val->String.length)
  Van.Tags.createTag(
    ~tagName="span",
    // ~children=[
    //   Van.Tags.Text(`The length of the text is: ${length.val->Int.toString}`),
    //   Van.Tags.DomNode(
    //     Van.Tags.createTag(
    //       ~tagName="input",
    //       ~properties={
    //         "type": "text",
    //         "value": vanText,
    //         "oninput": (event: Dom.event) => {
    //           vanText.val = event->getEventTarget->getInputValue
    //           Console.log2(length, vanText)
    //         },
    //       },
    //       ~children=[Van.Tags.Text("Input")],
    //     )
    //   ),
    //   // Van.Tags.Derived(length.val->Int.toString)
    // ],
    ~children=[
      // Van.Tags.childFromString(`The length of the text is: ${length.val->Int.toString}`),
      Van.Tags.childFrom(#Str("Hola mundo")),
      Van.Tags.childFrom(#Number(100.0)),
      // Van.Tags.childFromElement(Van.Tags.createTag(~tagName="input", ~properties={
      //   "type": "text",
      //   "value": vanText,
      //   "oninput": (event: Dom.event) => {
      //     vanText.val = event->getEventTarget->getInputValue
      //     Console.log2(length, vanText)
      //   }
      // }))
    ]
  )
}

Van.add(root, [deriveState()])->ignore
