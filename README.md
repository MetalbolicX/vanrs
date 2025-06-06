# VanRS

> `VanRS` provides bindings for [VanJS](https://vanjs.org/), which is lightest, zero-dependency reactive UI framework in the JavaScript ecosystem. By taking the advantage of the strongly-typed system of ReScript.

**Supported Versions:**

![VanJS](https://img.shields.io/badge/VanJS->=1.5.5-blue)
![ReScript](https://img.shields.io/badge/ReScript->=11.0.0-blue)


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
npm i vanjs-core vanrs
```

### 3. Update Configuration `rescript.json` file

In your `rescript.json` file, add the following dependency:

```json
{
  "bs-dependencies": ["vanrs"]
}
```

## Hello World Example

Here's a simple example of how to use `VanRS` to create a reactive UI component:

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

To build and run your ReScript application, see the [Compile and Run](https://metalbolicx.github.io/vanrs/#/compile-run) section.

## Documentation

<div align="center">

[![view - Documentation](https://img.shields.io/badge/view-Documentation-blue?style=for-the-badge)](https://metalbolicx.github.io/vanrs/#/api-index)

</div>

## Do you want to learn more?

- Check out the [VanJS documentation](https://vanjs.org/tutorial) for more information on how to use VanJS effectively.
- Explore the [ReScript documentation](https://rescript-lang.org/docs/manual/latest/introduction) for a deeper understanding of ReScript.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Technologies used

<table style="border: none;">
  <tr>
    <td align="center">
      <a href="https://vanjs.org/" target="_blank">
        <img src="./images/vanjs-logo.png" alt="VanJS" width="42" height="42" /><br/>
        <b>VanJS</b><br/>
      </a>
    </td>
    <td align="center">
      <a href="https://rescript-lang.org/" target="_blank">
        <img src="./images/rescript-logo.png" alt="ReScript" width="42" height="42" /><br/>
        <b>ReScript</b><br/>
      </a>
    </td>
  </tr>
</table>

## License

Released under [MIT](/LICENSE) by [@MetalbolicX](https://github.com/MetalbolicX).