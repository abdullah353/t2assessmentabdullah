class Results extends Backbone.Collection

  url : "result"
  model : Result
  db:
    view: "resultsByAssessmentId"
  initialize: () ->
  	console.log "#db Results Collection initialized"
  comparator: (model) ->
    model.get('timestamp') || 0
