# rescript-vanjs

## Description

`rescript-vanjs` provides bindings for [VanJS](https://vanjs.org/), which is lightest, zero-dependency reactive UI framework in the JavaScript ecosystem.By taking the advantage of the strongly-typed system of ReScript.

## Features

- Seamless integration of ReScript with VanJS.
- Type-safe bindings for VanJS functionality.
- Reactive UI components with minimal overhead.
- Easy-to-use API for creating dynamic web applications.

## Quick Installation

### 1. Create a ReScript Application

First, create a new ReScript application using one of the following commands:

```sh
npm create rescript-app@latest
```

For more information on setting up a ReScript project, refer to the [official ReScript documentation](https://rescript-lang.org/docs/manual/latest/installation).

### 2. Install Dependencies

Add the required dependencies to your project:

```sh
npm i vanjs-core rescript-vanjs
```

### 3. Update Configuration `rescript.json` file

In your `rescript.json` file, add the following dependency:

```json
{
  "bs-dependencies": ["rescript-vanjs"]
}
```

## Hello World Example

Here's a simple example of how to use `rescript-vanjs` to create a reactive UI component:

1. Create a file named `Main.res` in your `src` folder.
2. Add the following code to `Main.res`:

```rescript
@val @scope("document") @return(nullable)
external getElementById: string => option<Dom.element> = "getElementById"

let root = switch getElementById("root") {
| Some(el) => el
| None => Exn.raiseError("Root element not found")
}

let hello: unit => Dom.element = () => {
  Van.Tag.make("div")
  ->Van.Tags.addChild(Text("Hello, World!"))
  ->Van.Tags.build
}

Van.add(root, [Dom(hello())])->ignore
```

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

## Do you want to learn more?

- Check out the [VanJS documentation](https://vanjs.org/tutorial) for more information on how to use VanJS effectively.
- Explore the [ReScript documentation](https://rescript-lang.org/docs/manual/latest/introduction) for a deeper understanding of ReScript.

## Documentation

For detailed documentation on how to use `rescript-vanjs`, refer to the [API documentation](docs/api-index.md).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Technologies used

## Technologies used

<table>
  <tr>
    <td align="center">
      <a href="https://vanjs.org/" target="_blank">
        <img src="./images/vanjs-logo.png" alt="VanJS" width="42" height="42" /><br/>
        <b>VanJS</b><br/>
        <span style="color: #888;">Reactive UI Framework</span>
      </a>
    </td>
    <td align="center">
      <a href="https://rescript-lang.org/" target="_blank">
        <img src="./images/rescript-logo.png" alt="ReScript" width="42" height="42" /><br/>
        <b>ReScript</b><br/>
        <span style="color: #888;">Strongly-Typed Language</span>
      </a>
    </td>
  </tr>
</table>

## License

This project is licensed under the [MIT License](LICENSE).