import 'dart:mirrors';
import 'generator.dart';
import 'dart:async';
import 'dart:io';

main() async {
  await Future.wait(_classesExtending(Generator).map(_instantiate).map(_runGenerator));
}

List<ClassMirror> _classesExtending(Type t) {
  return _allClasses().where(_isExtendingTest(t));
}

typedef bool _Test(ClassMirror cM);

_Test _isExtendingTest(Type superClass) {
  return (ClassMirror cM) {
    return cM.isSubclassOf(reflectClass(superClass)) && cM.reflectedType != superClass;
  };
}

List<ClassMirror> _allClasses() {
  return _allLibraries().expand(_everyClassInLibrary);
}

List<LibraryMirror> _allLibraries() {
  return currentMirrorSystem().libraries.values;
}

List<ClassMirror> _everyClassInLibrary(LibraryMirror library) {
  return library.declarations.values.where((d) => d is ClassMirror);
}

_instantiate(ClassMirror classMirror) {
  return classMirror.newInstance(const Symbol(''), []).reflectee;
}

_runGenerator(Generator generator) async {
  await generator.run();
  exit(0);
}