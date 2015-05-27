part of clay.generator;

final Stream<List<int>> _stdin = stdin.asBroadcastStream();

class Query {
  final Type type;
  final Ask ask;
  final Object defaultValue;

  Query(Ask this.ask, Type this.type, Object this.defaultValue);

  Future<String> get _input => _stdin.first.then((l) => UTF8.decode(l));

  Future answer() async {
    if (type == bool) return _askBool();
    if (reflectClass(type).isEnum) return _askEnum();
    String input = await _ask();
    input = input.trimRight();
    if (_isEmpty(input) && defaultValue != null) return defaultValue;
    try {
      _verify(input);
    } catch (e) {
      _invalidInput(e.toString());
      return answer();
    }
    return _cast(input);
  }

  void _invalidInput(String message) {
    Console.setTextColor(Color.RED.id);
    print('Invalid input: $message');
    Console.resetAll();
  }

  Future<bool> _askBool() async {
    _ensureConsole();

    _writeQuestion();
    _writeDefaultBool();
    _writePrompt();

    stdin.echoMode = false;
    stdin.lineMode = false;
    String char = await _input;
    stdin.echoMode = true;
    stdin.lineMode = true;

    if (_isTruthyInput(char)) {
      print('yes');
      return true;
    }
    if (_isFalsyInput(char)) {
      print('no');
      return false;
    }
    print('…');
    _invalidInput('Please type [y] or [n]');
    return _askBool();
  }

  Future _askEnum() async {
    _ensureConsole();

    _writeQuestion();
    if (defaultValue != null)
      _writeDefaultValue();

    var options = _getEnumOptions();

    print('');

    Console.setTextColor(Color.CYAN.id);
    var out = '';
    for (var i = 1; i <= options.length; ++i) {
      out += ('$i. ${MirrorSystem.getName(options[i-1])}\n');
    }
    stdout.write(out.trim());
    Console.resetAll();

    _writePrompt();

    String response = await _input;

    try {
      if (_isEmpty(response) && defaultValue != null) return defaultValue;
      return reflectClass(type).getField(options[int.parse(response)-1]).reflectee;
    } catch(e) {
      _invalidInput('Type a number between 1 and ${options.length}');
      return _askEnum();
    }
  }

  List<Symbol> _getEnumOptions() {
    return reflectClass(type).declarations.values
    .where((d) => d is VariableMirror)
    .where((VariableMirror m) => m.isConst)
    .where((VariableMirror m) => !m.isPrivate)
    .where((VariableMirror m) => m.simpleName != #values)
    .map((VariableMirror m) => m.simpleName).toList();
  }

  bool _isTruthyInput(String char) {
    return char.toLowerCase() == 'y' || (_isEmpty(char) && defaultValue);
  }

  bool _isFalsyInput(String char) {
    return char.toLowerCase() == 'n' || (_isEmpty(char) && (defaultValue == false));
  }

  Future<String> _ask() async {
    _ensureConsole();

    _writeQuestion();
    if (defaultValue != null)
      _writeDefaultValue();
    if (ask.expression != null)
      _writeExpression();
    else if (type != dynamic)
      _writeType();

    _writePrompt();

    return _input;
  }

  void _ensureConsole() {
    if (!Console.initialized) Console.init();
  }

  void _writeQuestion() {
    Console.setUnderline(true);
    Console.setTextColor(Color.GOLD.id);
    stdout.write(ask.question);
    Console.resetAll();
  }

  void _writeDefaultValue() {
    _writeDefault(defaultValue.toString());
  }

  void _writeDefaultBool() {
    if (defaultValue == null) _writeDefault('y/n');
    else if (defaultValue) _writeDefault('Y/n');
    else _writeDefault('y/N');
  }

  void _writeDefault(String value) {
    Console.setTextColor(Color.RED.id);
    stdout.write(' ($value)');
    Console.resetAll();
  }

  void _writePrompt() {
    Console.setTextColor(Color.GREEN.id);
    stdout.write('\n? ');
    Console.resetAll();
  }

  void _writeExpression() {
    Console.setTextColor(Color.CYAN.id);
    stdout.write(' /${ask.expression}/');
    Console.resetAll();
  }

  void _writeType() {
    Console.setTextColor(Color.CYAN.id);
    stdout.write(' $type');
    Console.resetAll();
  }

  void _verify(String input) {
    if (_isEmpty(input)) throw 'This question is required.';

    if (type == int) _verifyInt(input);
    if (type == double) _verifyDouble(input);

    if (ask.expression != null) _verifyExpression(input);
  }

  void _verifyInt(String input) {
    try {
      int.parse(input);
    } on FormatException {
      throw 'Must be an integer';
    }
  }

  void _verifyDouble(String input) {
    try {
      double.parse(input);
    } on FormatException {
      throw 'Must be a floating number';
    }
  }

  void _verifyExpression(String input) {
    if (!new RegExp(ask.expression).hasMatch(input))
      throw 'Must match this expression: /${ask.expression}/';
  }

  bool _isEmpty(String input) => input.trim() == '';

  dynamic _cast(String input) {
    if (type == int) return int.parse(input);
    if (type == double) return double.parse(input);
    return input;
  }
}
