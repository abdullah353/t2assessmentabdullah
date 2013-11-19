class Subtests extends Backbone.Collection
  
  url: "subtest"
  model: Subtest
  db:
    view: "subtestsByAssessmentId"

  comparator: (subtest) ->
    subtest.get "order"
  
  initialize: (options) ->
    console.log "I am Subtests Collection initialize"
  fetch: (options) ->
    console.log "#db Below if the arguments of Fetch Subtests Collection"
    console.log options
    console.log "#db what is super in Collection Subtests"
    console.log super
    super options

  # call this after you load the collection you're going to be working with
  maintainOrder: ->
    test = (model.get("order") for model in @models).join("")
    ordered = (i for model,i in @models).join("")
    if test != ordered
      for subtest, i in @models
        subtest.set "order", i
        subtest.save()
  
