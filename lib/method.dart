part of clay;

class Method extends Variable implements CodeEntity {
  String name;

  Method(String name) : super(name) {
    this.name = name;
  }

  toString() {
    var type = _typeToString();
    return '''
$type $name();
    '''.trim();
  }

  String _typeToString() {
    if (type == null) return 'void';
    if (type is Class) return (type as Class).name;
    return type.toString();
  }
}
