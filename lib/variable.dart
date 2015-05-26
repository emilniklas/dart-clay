part of clay;

class Variable implements CodeEntity {
  final String name;
  Object type;
  Object value;

  Variable(String this.name);

  String toString() {
    var type = _typeToString();
    var value = (this.value == null) ? '' : ' = ' + _valueToString();
    return '$type $name$value';
  }

  String _typeToString() {
    if (type == null) return 'var';
    if (type is Class) return (type as Class).name;
    return type.toString();
  }

  String _valueToString() {
    if (value == null) return;
    if (value is String) return "'$value'";
    if (value is Variable) return (value as Variable).name;
    return value.toString();
  }
}
