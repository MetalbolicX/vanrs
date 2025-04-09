open Test

let isIntEqualTo: (int, int, ~message: string=?) => unit = (a, b, ~message as msg="") =>
  assertion((a, b) => a == b, a, b, ~message=msg, ~operator="Int equals")

let isTruthy: (bool, ~message: string=?) => unit = (a, ~message as msg="") =>
  assertion((a, b) => a == b, a, true, ~operator="Equals to true", ~message=msg)
