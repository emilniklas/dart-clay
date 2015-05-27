import 'package:clay/clay.dart';
//export 'package:clay/run.dart';
import 'dart:async';
//import 'package:path/path.dart';
import 'dart:io';
import 'dart:isolate';

class BridgeGenerator extends Generator {

  @Ask('How old are you?')
  int age = 13;

  @Ask('What should the application be called?')
  String name;


  Future run() async {

    await ask(#age);

    name = 'app_$age';

    await ask();

    await finishGenerators();
    print('Generator done');
//    await new Library(name).writeTo(new Directory('out'));
  }
}

main() async {

  Isolate isol = await Isolate.spawn(_run, null);
  var exitPort = new ReceivePort();
  isol.addOnExitListener(exitPort.sendPort);
  await exitPort.first;
  exitPort.close();
  print('back to reality');

//  stdin.listen((data) {
//    print('hee');
//    print(data);
//  });
}

_run(_) => new BridgeGenerator().run();