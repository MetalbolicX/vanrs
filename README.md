# rescript-vanjs

## Description

ReScript-VanJS provides bindings for [VanJS](https://vanjs.org/), an ultra-lightweight, zero-dependency reactive UI framework. This project enables developers to create web applications using ReScript, a strongly-typed programming language that compiles to JavaScript, in combination with the simplicity and efficiency of VanJS.

## Features

- Seamless integration of ReScript with VanJS.
- Type-safe bindings for VanJS functionality.
- Reactive UI components with minimal overhead.
- Easy-to-use API for creating dynamic web applications.

## Installation

### 1. Create a ReScript Application

First, create a new ReScript application using one of the following commands:

```sh
npm create rescript-app@latest
```

```sh
pnpm create rescript-app
```

```sh
bun create rescript-app
```

For more information on setting up a ReScript project, refer to the [official ReScript documentation](https://rescript-lang.org/docs/manual/latest/installation).

### 2. Install Dependencies

Add the required dependencies to your project:

```sh
npm install vanjs-core rescript-vanjs
```

```sh
pnpm add vanjs-core rescript-vanjs
```

```sh
bun add vanjs-core rescript-vanjs
```

### 3. Update Configuration

In your `rescript.json` file, add the following dependency:

```json
{
  "bs-dependencies": ["rescript-vanjs"]
}
```

## Usage

Here's a simple example of how to use ReScript-VanJS to create a reactive UI component:

1. Create a file named `Main.res` in your `src` folder.
2. Add the following code to `Main.res`:

```rescript
@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Js.Exn.raiseError("Root element not found")
}

@get external getEventTarget: Dom.event => Dom.eventTarget = "target"
@get external getInputValue: Dom.eventTarget => string = "value"

let deriveState: unit => Dom.element = () => {
  let vanText = Van.state("VanJs")
  let length = Van.derive(() => vanText.val->String.length)
  Van.Tags.createTag(
    ~tagName="span",
    ~children=[
      Van.Tags.childFrom(#Text(`The length of the text is: `)),
      Van.Tags.childFrom(#Dom(Van.Tags.createTag(~tagName="input", ~properties={
        "type": "text",
        "value": vanText,
        "oninput": (event: Dom.event) => {
          vanText.val = event->getEventTarget->getInputValue
        }
      }))),
      Van.Tags.childFrom(#State(length))
    ]
  )
}

Van.add(root, [deriveState()])->ignore
```

This example creates a reactive input field that displays the length of its content in real-time.

## Build and Run

Follow these steps to build and run your rescript-vanjs application:

1. Start the ReScript development server:
   ```sh
   npm run res:dev
   ```

2. If there are no errors, build the JavaScript files:
   ```sh
   npm run res:build
   ```

3. Build the JavaScript bundle for browser use. For example, using [Bun](https://bun.sh/) (you can use any other JavaScript bundler):
   ```sh
   bun build ./src/Main.res.mjs --outdir ./out --format esm
   ```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- [ReScript](https://rescript-lang.org/) for the excellent type-safe language
- [VanJS](https://vanjs.org/) for the lightweight reactive UI framework

```