part of clay.generator;

abstract class Generator {
  Future run();
  Map<Symbol, VariableMirror> _questionFields;

  Generator() {
    var aQ = _allQuestionFields();
    _questionFields = new Map.fromIterables(aQ.map((v)=>v.simpleName), aQ);
  }

  Future ask([Symbol field]) async {
    if (field != null) return _askSingle(field);

    for (var dM in new List.from(_questionFields.values)) {
      await _askQuestion(dM);
    }
  }

  Future _askSingle(Symbol field) {
    return _askQuestion(_questionFields[field]);
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
    _questionFields.remove(field.simpleName);
  }

  Ask _getQuestion(DeclarationMirror dM) {
    return dM.metadata.firstWhere(_isAskAnnotation).reflectee;
  }

  bool _isEmpty(String input) {
    return input.trim() == '';
  }
}
