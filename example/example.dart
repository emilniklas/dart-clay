import 'package:clay/clay.dart';
export 'package:clay/run.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';

class BridgeGenerator extends Generator {

  @Ask('What should the application be called?')
  String name = basename(Directory.current.path);

  @Ask('What should the class be called?')
  String className;

  Future run() async {

    await ask(#name);
    className = name.replaceAllMapped(new RegExp(r'[._](\w)'), (m) => m[1].toUpperCase());
    className = className[0].toUpperCase() + className.substring(1);
    await ask();



    var lib = new Library(name);

    lib.addClass(new Class(className)
    ..method(new Method('testMethod')
    ..type = int));

    var dir = new Directory(name)..createSync(recursive: true);

    await new Yaml('test', [
      {
        'key': 'value',
        'nested': {
          'object': [
            'list'
          ]
        }
      },
      'hej'
    ]).writeTo(dir);

    await lib.writeTo(dir);
  }
}