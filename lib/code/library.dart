part of clay.code;

class Library extends File implements CodeEntity {
  final List<String> _imports = [];
  final List<String> _exports = [];
  final List<File> parts = [];
  String name;

  Library(String name) : super(name) {
    this.name = name;
  }

  import(String declaration) {
    _imports.add(declaration);
  }

  export(String declaration) {
    _exports.add(declaration);
  }

  part(File file) {
    file.partOf(this);
    parts.add(file);
  }

  String toString() {
    var pieces = [
      'library $name;',
      _importsExports(),
      _partsToString(),
      super.toString(),
    ]
      ..removeWhere(_isEmpty);
    return pieces.join('\n\n');
  }

  String _importsExports() {
    return _importsToString() + '\n' + _exportsToString().trim();
  }

  String _importsToString() {
    return _imports.map(_importToString).join('\n');
  }

  String _exportsToString() {
    return _exports.map(_exportToString).join('\n');
  }

  String _importToString(String import) {
    return "import '$import';";
  }

  String _exportToString(String export) {
    return "export '$export';";
  }

  String _partsToString() {
    return parts.map(_partToString).join('\n');
  }

  String _partToString(File part) {
    return "part '${part.filename}';";
  }

  Future writeTo(io.Directory directory) async {
    var oldCurrent = io.Directory.current;
    io.Directory.current = directory;
    await _writeFile(this);
    await Future.wait(parts.map(_writeFile));
    io.Directory.current = oldCurrent;
  }

  Future _writeFile(File file) async {
    await file.create(recursive: true);
    await file.writeAsString(file.toString());
  }

  bool _isEmpty(String input) {
    return input.trim() == '';
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
