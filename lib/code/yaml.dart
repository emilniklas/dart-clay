part of clay.code;

class Yaml extends File {
  final Object writable;

  Yaml(String filename, this.writable) : super(filename) {
    this.filename = '${filename}.yaml';
  }

  String toString() {
    return toYamlString(writable);
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
