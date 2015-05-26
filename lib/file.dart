part of clay;

class File implements io.File {
  String filename;
  final List<Class> _classes = [];
  final List<Variable> _globalVariables = [];
  final List<Method> _globalFunctions = [];
  Library _library;

  File(String filename) {
    this.filename = '$filename.dart';
  }

  void partOf(Library library) {
    this._library = library;
  }

  void addClass(Class c) {
    _classes.add(c);
  }

  void addVariable(Variable v) {
    _globalVariables.add(v);
  }

  String toString() {
    var out = '';
    if (_library != null)
      out += "part of ${_library.name};\n\n";
    if (_globalVariables.isNotEmpty)
      out += _globalVariablesToString() + '\n\n';
    if (_globalFunctions.isNotEmpty)
      out += _globalFunctionsToString() + '\n\n';
    if (_classes.isNotEmpty)
      out += _classesToString() + '\n\n';
    return out.trim();
  }

  String _globalVariablesToString() {
    return _globalVariables.map((e) => e.toString()+';').join('\n');
  }

  String _globalFunctionsToString() {
    return _globalFunctions.map((e) => e.toString()).join('\n\n');
  }

  String _classesToString() {
    return _classes.map((e) => e.toString()).join('\n\n');
  }

  Future writeTo(io.Directory directory) async {
    var oldCurrent = io.Directory.current;
    io.Directory.current = directory;
    await _writeFile(this);
    io.Directory.current = oldCurrent;
  }

  Future _writeFile(File file) async {
    await file.create(recursive: true);
    await file.writeAsString(file.toString());
  }

  io.File get _file => new io.File(this.filename);

  noSuchMethod(Invocation invocation) {
    return reflect(_file).delegate(invocation);
  }
}
