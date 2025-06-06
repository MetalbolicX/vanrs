# Getting Started

## Setup environment

ReScrtipt can work on modern JavaScript runtimes, including [Node.js](https://nodejs.org), [Deno](https://deno.com/), [Bun](https://bun.sh/).

### For Node.js

To work with Node.js, you must have version 14 or higher installed. This is a requirement for ReScript version 11.

Check your Node.js version with the following command:
```sh
node -v
```

If you do not have Node.js installed in your current environment, or the installed version is too low, you can use [nvm](https://github.com/nvm-sh/nvm) to install the latest version of Node.js.

## Create a new project

Navigate to the folder where your project will be created and run the following command to create a new directory:
```sh
mkdir my-re-vanjs-app && cd my-re-vanjs-app
```

Initialize a `package.json` file using one of the following commands:

<!-- tabs:start -->

#### **npm**
```sh
npm init
```

#### **pnpm**
```sh
pnpm init
```

#### **yarn**
```sh
yarn init
```

#### **bun**
```sh
bun init
```

#### **deno**
```sh
deno init
```

<!-- tabs:end -->


### Install Dependencies

Install `VanJS`, `ReScript`, and `VanRS` using your preferred package manager:

<!-- tabs:start -->

#### **npm**
```sh
npm install vanjs-core rescript @rescript/core vanrs
```


#### **pnpm**
```sh
pnpm add vanjs-core rescript @rescript/core vanrs
```


#### **yarn**
```sh
yarn add vanjs-core rescript @rescript/core vanrs
```


##### **bun**
```sh
bun add vanjs-core rescript @rescript/core vanrs
```


#### **deno**
```sh
deno add --npm vanjs-core rescript @rescript/core vanrs
```

<!-- tabs:end -->

### Create the `rescript.json` File

Create a `rescript.json` file at the root of your project:

<!-- tabs:start -->

#### **Unix**
```sh
touch rescript.json
```

#### **Windows**
```powershell
New-Item -Path ".\rescript.json" -ItemType File
```

<!-- tabs:end -->

In the `rescript.json` file, add the following content:
```json
{
  "name": "your-project-name",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    }
  ],
  "package-specs": [
    {
      "module": "esmodule",
      "in-source": true
    }
  ],
  "suffix": ".res.mjs",
  "bs-dependencies": [
    "@rescript/core",
    "vanrs"
  ],
  "bsc-flags": [
    "-open RescriptCore"
  ]
}
```

?> For a more advanced configuration of the `rescript.json` file, you can read the [Rescript documentation](https://rescript-lang.org/docs/manual/v11.0.0/build-configuration).

### Helper Commands

Add the following scripts to your `package.json` to compile your `.res` files to JavaScript:

```json
"scripts": {
  "res:dev": "rescript -w",
  "res:build": "rescript",
  "res:clean": "rescript clean"
}
```

?> If you want more information about how to set up your ReScript project, you can check the [ReScript installation documentation](https://rescript-lang.org/docs/manual/v11.0.0/installation).