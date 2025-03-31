let checkIntEqual: (int, int, ~message: string=?) => unit = (a, b, ~message as msg="") => {
  Test.assertion((a, b) => a == b, a, b, ~message=msg, ~operator="Int equals")
}
