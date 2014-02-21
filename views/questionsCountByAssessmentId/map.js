function(doc) {
  if (doc.collection == 'subtest' && doc.prototype == "survey") {
    if(doc.customValidationMessage && doc.customValidationMessage != ''){
  emit(doc.assessmentId, Number(doc.customValidationMessage));
  }else{
emit(doc.assessmentId, 1);
}
  }
}