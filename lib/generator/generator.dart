part of clay.generator;

abstract class Generator {
  Future run();

  Future ask() async {
    for (var dM in _allQuestionFields()) {
      await _askQuestion(dM);
    }
  }

  List<VariableMirror> _allQuestionFields() {
    return reflect(this).type.declarations.values.where(_isQuestionField);
  }

  bool _isQuestionField(VariableMirror v) {
    return v.metadata.any(_isAskAnnotation) && v is VariableMirror;
  }

  bool _isAskAnnotation(InstanceMirror iM) {
    return iM.reflectee is Ask;
  }

  Future _askQuestion(VariableMirror field) async {
    var question = _getQuestion(field);
    var type = field.type.reflectedType;
    var defaultValue = reflect(this).getField(field.simpleName).reflectee;

    reflect(this).setField(field.simpleName, await new Query(question, type, defaultValue).answer());
  }

  Ask _getQuestion(DeclarationMirror dM) {
    return dM.metadata.firstWhere(_isAskAnnotation).reflectee;
  }

  bool _isEmpty(String input) {
    return input.trim() == '';
  }
}
