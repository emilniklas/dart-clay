import 'package:clay/clay.dart' as clay;
import 'dart:io';

main() {
  var library = new clay.Library('my_library')
    ..import('dart:async')
    ..import('package:bridge/cli.dart')
    ..export('package:bridge/cli_init.dart');

  var part = _theFile();

  library.part(part);

  _printIt(library);

//  library.writeTo(new Directory('out'));
}

_printIt(clay.Library library) {
  _printFile(library);
  library.parts.forEach(_printFile);
}

_printFile(clay.File file) async {
  print('=' * 20);
  print(file.filename);
  print('-' * 20);
  print(file);
}

clay.File _theFile() {
  var inter = _theInterface();
  var var1 = new clay.Variable('test')
    ..type = String
    ..value = '1300';
  var var2 = new clay.Variable('testAgain')
    ..type = String
    ..value = var1;
  return new clay.File('subdir/example_file')
    ..addClass(inter)
    ..addClass(_theClass(inter))
    ..addVariable(var1)
    ..addVariable(var2);
}

clay.Class _theClass(clay.Class interface) {
  return new clay.Class('MyClass')
    ..implement(interface);
}

clay.Class _theInterface() {
  return new clay.Class('MyInterface')
    ..method(new clay.Method('testMethod')..type = int)
    ..abstract = true;
}