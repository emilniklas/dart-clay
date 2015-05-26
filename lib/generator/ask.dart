part of clay.generator;

class Ask {
  final String question;
  final String expression;
  const Ask(String this.question, [String this.expression]);

  bool test(Object input) {
    if (expression == null) return true;
    return new RegExp(expression).hasMatch(input.toString());
  }
}
