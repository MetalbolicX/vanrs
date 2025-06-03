# Tutorials

## Project: Count the number of words in a text

You will create a simple application that counts the number of words in a text input. This tutorial will guide you through the process of setting up a VanJS application with ReScript.

?> This tutorial assumes you have a basic understanding of ReScript and JavaScript. If you're new to ReScript, consider checking out the [ReScript documentation](https://rescript-lang.org/docs/manual/latest/introduction) first.

### First Setup

You need to setup the environment for ReScript and VanJS. If you haven't done this yet, please follow the [Getting Started](/getting-started) guide.

### Create the `src` directory and `CountWords.res` file
Create a directory named `src` in your project root. This is where you will write your ReScript code.

<!-- tabs:start -->

#### **Unix**
```sh
mkdir src && touch ./src/CountWords.res
```

#### **Windows**
```powershell
mkdir src && New-Item -Path ".\src\CountWords.res" -ItemType File
```

<!-- tabs:end -->

### `index.html` file

Create an `index.html` file in your project root. This file will serve as the entry point for your VanJS application.

<!-- tabs:start -->

#### **Unix**
```sh
touch index.html
```

#### **Windows**
```powershell
New-Item -Path ".\index.html" -ItemType File
```

<!-- tabs:end -->

Open the `index.html` file in a text editor of your choice and add the following code:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Count Words</title>
  </head>
  <body>
      <div id="root"></div>
      <script src="./src/CountWords.res.js" type="module"></script>
  </body>
</html>
```

This HTML file includes a `div` with the ID `root`, which will be the container for your VanJS application. It also includes a script tag that loads the compiled JavaScript from your ReScript code.

### Code for `CountWords.res` file

Open the `CountWords.res` file in the text editor of your choice and add the following code:

```reason
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
```