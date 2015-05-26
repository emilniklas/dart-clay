part of clay.code;

class Class implements CodeEntity {
  final String name;
  final List<Class> _implementations = [];
  bool abstract = false;
  Class _parent;
  final List<Constructor> _constructors = [];
  final List<Method> _methods = [];
  final List<Variable> _properties = [];

  Class(String this.name);

  void implement(Class interface) {
    _implementations.add(interface);
  }

  void extend(Class parent) {
    _parent = parent;
  }

  void method(Method method) {
    _methods.add(method);
  }

  toString() {
    var abstract = (this.abstract) ? 'abstract ' : '';
    var parent = (_parent != null) ? ' extends ${_parent.name}' : '';
    var implementations = _implementations.map((c) => c.name).join(', ');
    if (implementations != '') implementations = ' implements $implementations';
    return '''
${abstract}class $name$parent$implementations {
${_indent(_body(), 1)}
}
    '''.trim();
  }

  String _body() {
    return _propertiesToString()
    + _constructorsToString()
    + _methodsToString().trim();
  }

  String _propertiesToString() {
    if (_properties.isEmpty) return '';

    return '\n';
  }

  String _constructorsToString() {
    return '';
  }

  String _methodsToString() {
    if (_methods.isEmpty) return '';
    var methods = _methods.map((m) => m.toString()).join('\n\n');
    return '$methods\n';
  }
}
