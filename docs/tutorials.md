# Tutorials

## Project: Count the number of characters in a text

You will create a simple application that counts the number of characters in a text input. This tutorial will guide you through the process of setting up a VanJS application with ReScript.

?> This tutorial assumes you have a basic understanding of ReScript and JavaScript. If you're new to ReScript, consider checking out the [ReScript documentation](https://rescript-lang.org/docs/manual/latest/introduction) first.

### First Setup

You need to setup the environment for ReScript and VanJS. If you haven't done this yet, please follow the [Getting Started](/getting-started) guide.

### Create the `src` directory and `CountCharacters.res` file
Create a directory named `src` in your project root. This is where you will write your ReScript code.

<!-- tabs:start -->

#### **Unix**
```sh
mkdir src && touch ./src/CountCharacters.res
```

#### **Windows**
```powershell
mkdir src && New-Item -Path ".\src\CountCharacters.res" -ItemType File
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
    <title>Count Characters</title>
  </head>
  <body>
      <div id="root"></div>
      <script src="./src/CountCharacters.res.js" type="module"></script>
  </body>
</html>
```

This HTML file includes a `div` with the ID `root`, which will be the container for your VanJS application. It also includes a script tag that loads the compiled JavaScript from your ReScript code.

### Code for `CountCharacters.res` file

Open the `CountCharacters.res` file in the text editor of your choice and add the following code:

```reason
@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget_like<Dom.htmlInputElement> = "target"
@get external getInputValue: Dom.eventTarget_like<Dom.htmlInputElement> => string = "value"

let countCharactersComponent: unit => Dom.element = () => {
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

Van.add(root, [Dom(countCharactersComponent())])->ignore
```
**Code Explanation:**

- Create the necessary bindings to manipulate the DOM using the strong typing of ReScript. For example, `getElementById` is used to get the element which has the id `root`. For further information on how to use the DOM API in ReScript, refer to the [ReScript DOM API documentation](https://rescript-lang.org/docs/manual/v11.0.0/api/dom).
- Create a ReScript function which creates a component that will render the input field and display the character count.
- Use `Van.state` to create a state variable `initText` that holds the initial text value.
- Use `Van.derive` to create a derived state variable `textLength` that calculates the length of the text in `initText`.
- Use `Van.Tags.make` to create a `div` element that contains:
  - A text node displaying the length of the text.
  - An input field that updates the `initText` state variable on input.
  - A state component that displays the length of the text.
- Finally, use `Van.add` to add the component to the root element.

### Compile the ReScript code

Follow the steps to [compile and run](/compile-run) your ReScript code.

Now you can open the `index.html` file in your browser to see the application in action. You should see an input field where you can type text, and the length of the text will be displayed next to it.

Congratulations! You have successfully created a simple VanJS application that counts the number of characters in a text input using ReScript. You can now extend this application further by adding more features or styling it to your liking.