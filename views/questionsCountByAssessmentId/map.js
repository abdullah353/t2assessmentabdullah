function(doc) {
  if (doc.collection == 'subtest' && doc.prototype == "survey") {
    emit(doc.assessmentId, 1);
  }
}
