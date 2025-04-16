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
  // Van.Tags.createTag(
  //   ~tagName="span",
  //   ~children=[
  //     Van.Child.text("The length of the text is: "),
  //     Van.Child.dom(
  //       Van.Tags.createTag(
  //         ~tagName="input",
  //         ~properties={
  //           "type": "text",
  //           "value": vanText,
  //           "oninput": (evt: Dom.event) => {
  //             vanText.val = evt->getEventTarget->getInputValue
  //           },
  //         },
  //       ),
  //     ),
  //     Van.Child.stateChild(length),
  //   ],
  // )
  Van.Dom.createElement("span")
  ->Van.Dom.addChild(Van.Child.text("The length of the text is: "))
  ->Van.Dom.addChild(Van.Child.stateChild(length))
  ->Van.Dom.build
}

Van.add(root, deriveState())->ignore
