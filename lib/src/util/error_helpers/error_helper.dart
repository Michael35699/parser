///
/// A collection of classes that is supposed to help
/// in creating error messages. I think it's useless.
///

abstract class ErrorHelper {
  const ErrorHelper();
}

///
/// Generates messages that start with "Expected ..."
///
class ExpectedErrorHelper extends ErrorHelper {
  const ExpectedErrorHelper();

  String an(String value) => "Expected an $value.";
  String a(String value) => "Expected a $value.";
  String the(String value) => "Expected the $value.";
  String value(String value) => "Expected value $value.";
  String call(String value) => "Expected $value.";
}

///
/// Generates messages that start with "Unexpected ..."
///
class UnexpectedErrorHelper extends ErrorHelper {
  const UnexpectedErrorHelper();

  String value(String value) => "Unexpected value $value.";
  String call(String value) => "Unexpected $value.";
}

const ExpectedErrorHelper expected = ExpectedErrorHelper();
const UnexpectedErrorHelper unexpected = UnexpectedErrorHelper();
