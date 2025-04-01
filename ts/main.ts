import van from "vanjs-core";

const { input, span } = van.tags;

const DerivedState = () => {
  const text = van.state("VanJS");
  const length = van.derive(() => text.val.length);
  return span(
    "The length of ",
    input({
      type: "text",
      value: text,
      oninput: ({ target }) => (text.val = target.value),
    }),
    " is ",
    length,
    "."
  );
};

const root = document!.getElementById("root") as HTMLElement;

van.add(root, DerivedState());
