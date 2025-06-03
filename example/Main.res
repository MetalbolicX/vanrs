@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget_like<Dom.htmlInputElement> = "target"
@get external getInputValue: Dom.eventTarget_like<Dom.htmlInputElement> => string = "value"

let countWordsComponent: unit => Dom.element = () => {
  let initText = Van.state("VanJs")
  let textLength = Van.derive(() => initText.val->String.length)

  Van.Tags.make("div")
  ->Van.Tags.appendChildren([
    Text("The length of the text is: "),
    Dom(
      Van.Tags.make("input")
      ->Van.Tags.attr({
        "type": "text",
        "value": initText.val,
        "oninput": (event: Dom.event) => initText.val = event->getEventTarget->getInputValue,
      })
      ->Van.Tags.build,
    ),
    State(textLength),
  ])
  ->Van.Tags.build
}

Van.add(root, [Dom(countWordsComponent())])->ignore
