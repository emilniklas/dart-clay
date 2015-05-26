import 'package:clay/clay.dart';
export 'package:clay/run.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'dart:io';

class BridgeGenerator extends Generator {

  @Ask('What should the application be called?')
  String name = basename(Directory.current.path);

  Future run() async {

    await ask();

    var lib = new Library(name);

    lib.addClass(new Class('MyNewClass')
    ..method(new Method('testMethod')
    ..type = int));

    await lib.writeTo(new Directory(name)..createSync(recursive: true));
  }
}