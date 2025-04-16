@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget = "target"
@get external getInputValue: Dom.eventTarget => string = "value"

let deriveState: unit => Dom.element = () => {
  let vanText = Van.state("VanJs")
  let length = Van.derive(() => vanText.val->String.length)

  open Van.Child
  Van.Dom.createElement("span")
  ->Van.Dom.addChildren([
    "The length of the text is: "->toText,
    Van.Dom.createElement("input")
    ->Van.Dom.withProps({
      "type": "text",
      "value": vanText,
      "oninput": (event: Dom.event) => vanText.val = event->getEventTarget->getInputValue,
    })
    ->Van.Dom.build
    ->toDom,
    length->toState,
  ])
  ->Van.Dom.build
}

Van.add(root, deriveState())->ignore
