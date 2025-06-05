# Compile and Run ReScript Code

Now that you have finished writting your ReScript, it is to be used in a JavaScript runtime or the browser. ReScript code cannot be directly used, so you need to compile it first.

 1. To compile your ReScript code, first it is necessary to check whether there are error in your code or not. You can do this by running the following command as long in the `package.json` file you have the `res:dev` script defined (if it is not defined, check the [Getting Started](/getting-started#Helper-commands) guide):

<!-- tabs:start -->

#### **npm**
```sh
npm run res:dev
```
#### **pnpm**
```sh
pnpm run res:dev
```

#### **yarn**
```sh
yarn res:dev
```

#### **bun**
```sh
bun run res:dev
```

#### **deno**
```sh
deno run res:dev
```

<!-- tabs:end -->

2. If there are no errors, you can compile your ReScript code to JavaScript by running the following command:

<!-- tabs:start -->

#### **npm**
```sh
npm run res:build
```

#### **pnpm**
```sh
pnpm run res:build
```

#### **yarn**
```sh
yarn res:build
```

#### **bun**
```sh
bun run res:build
```

#### **deno**
```sh
deno run res:build
```

<!-- tabs:end -->

3. After compiling, the JavaScript file (or files) will be generated aside each `.res` file. However, the file (or files) are may not be ready to be used in the browser or a JavaScript environment yet, so you need to bundle them. You can do this by adding any bundler of your choice, such as [esbuild](https://esbuild.github.io/), [rollup](https://rollupjs.org/), [rsbuild](https://rsbuild.rs/), or [webpack](https://webpack.js.org/).

For this tutorial, we will use [rolldown](https://rolldown.rs/), which is a bundler that is easy to use and has a good performance. To install it, run the following command:

<!-- tabs:start -->

#### **npm**
```sh
npm install -D rolldown
```

#### **pnpm**
```sh
pnpm add -D rolldown
```

#### **yarn**
```sh
yarn add -D rolldown
```

#### **bun**
```sh
bun add -D rolldown
```

#### **deno**
```sh
deno add -D --npm rolldown
```

<!-- tabs:end -->

4. After installing `rolldown`, can execute the following command to bundle your ReScript code:

```sh
rolldown ./src/<Name of your .res file>.res.mjs --file ./src/<Name of .res file>.res.js --format es
```