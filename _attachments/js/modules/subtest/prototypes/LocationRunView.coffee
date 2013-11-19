class LocationRunView extends Backbone.View

  events:
    "click .school_list li" : "autofill"
    "keyup input.search"  : "showOptions"
    "click .clear" : "clearInputs"

  initialize: (options) ->
    console.log "Options in initialize"
    console.log @samAssessmentId
    @pendResAr = []
    @compResAr = []
    @emptyResult=[]
    @penNam =[]
    @compNam = []
    @samAssessmentId = options.parent.model.attributes.assessmentId
    @resultarray = new Results
    @resultarray.fetch
      "_id" : @samAssessmentId
      success: (gotresult) =>
        _.each gotresult.models , (result3) =>
          console.log result3
          if _.last(result3.attributes.subtestData)?.data.end_time? 
            @compResAr.push result3.attributes.subtestData
          else 
            @pendResAr.push(result3.attributes.subtestData)
            @emptyResult.push _(result3).pluck("_id") if result3.attributes.subtestData.length == 1

        console.log "Pending Results Array"
        console.log @pendResAr
        _.each @pendResAr , (items) =>
          _.each items , (item) =>
            if item?.prototype? and item.prototype == "location" and item.data?.location?
              @penNam.push item.data.location

        console.log "Completed Reuslt"
        console.log @compResAr
        _.each @compResAr , (items) =>
          _.each items , (item) =>
            if item?.prototype? and item.prototype == "location" and item.data?.location?
              @compNam.push item.data.location
              console.log @compNam

    @model  = @options.model
    @parent = @options.parent
    
    @levels = @model.get("levels")       || []
    @locations = @model.get("locations") || []
    console.log "Locations are"
    console.log @locations
    if @levels.length == 1 && @levels[0] == ""
      @levels = []
    if @locations.length == 1 && @locations[0] == ""
      @locations = []

    @haystack = []

    for location, i in @locations
      @haystack[i] = []
      for locationData in location
        @haystack[i].push locationData.toLowerCase()
        console.log "@haystack result is"
        console.log @haystack
    
    template = "<li data-index='{{i}}'>"
    for level, i in @levels
      template += "{{level_#{i}}}"
      template += " - " unless i == @levels.length-1
    template += "</li>"
    
    @li = _.template(template)

  clearInputs: ->
    for level, i in @levels
      @$el.find("#level_#{i}").val("")

  autofill: (event) ->
    @$el.find(".autofill").fadeOut(250)
    index = $(event.target).attr("data-index")
    location = @locations[index]
    for level, i in @levels
      @$el.find("#level_#{i}").val(location[i])


  showOptions: (event) ->
    needle = $(event.target).val().toLowerCase()
    console.log "needle is"
    console.log needle
    if needle == ''
      $('.autofill').hide()
    else
      field = parseInt($(event.target).attr('data-level'))
      # hide if others are showing
      for otherField in [0..@haystack.length]
        @$el.find("#autofill_#{otherField}").hide()

      atLeastOne = false
      results = []
      for stack, i in @haystack
        isThere = ~@haystack[i][field].indexOf(needle)
        results.push i if isThere
        atLeastOne = true if isThere
      
      for stack, i in @haystack
        for otherField, j in stack
          if j == field
            continue
          isThere = ~@haystack[i][j].indexOf(needle)
          results.push i if isThere && !~results.indexOf(i)
          atLeastOne = true if isThere
      
      if atLeastOne
        html = ""
        for result in results
          html += @getLocationLi result
        @$el.find("#autofill_#{field}").fadeIn(250)
        @$el.find("#school_list_#{field}").html html

      else
        @$el.find("#autofill_#{field}").fadeOut(250)

  getLocationLi: (i) ->
    templateInfo = "i" : i
    for location, j in @locations[i]
      templateInfo["level_" + j] = location
      abc = @li templateInfo
      _.each @compNam, (completename) ->
        #important to keep type of same to comparison
        a = []
        a.push location
        abc = abc.replace "<li","<li style='color:green;'" if _.isEqual a, completename
      _.each @penNam, (pendingname) ->
        #important to keep type of same to comparison
        a = []
        a.push location
        abc = abc.replace "<li","<li style='color:red;'" if _.isEqual a, pendingname
      console.log abc
    return abc

  render: ->
    schoolListElements = ""

    html = "
      <button class='clear command'>Clear</button>
      ";

    for level, i in @levels
      html += "
        <div class='label_value'>
          <label for='level_#{i}'>#{level}</label><br>
          <input class='search' val='' data-level='#{i}' id='samSearchBox' placeholder='Search For Student Name'>
          <labe>Selected Student Name: </label>
          <input data-level='#{i}' id='level_#{i}' value='' disabled>
        </div>
        <div id='autofill_#{i}' class='autofill' style='display:none'>
          <h2>Select one from autofill list</h2>
          <ul class='school_list' id='school_list_#{i}'>
          </ul>
        </div>
    "

    @$el.html html

    @trigger "rendered"

  getResult: ->
    return {
      "labels"   : (level.replace(/[\s-]/g,"_") for level in @levels)
      "location" : ($.trim(@$el.find("#level_#{i}").val()) for level, i in @levels)
    }

  getSkipped: ->
    return {
      "labels"   : (level.replace(/[\s-]/g,"_") for level in @levels)
      "location" : ("skipped" for level, i in @levels)
    }


  isValid: ->
    @$el.find(".message").remove()
    for input in @$el.find("input")
      return false if $(input).val() == ""
    true

  showErrors: ->
    for input in @$el.find("input")
      if $(input).val() == ""
        $(input).after " <span class='message'>#{$('label[for='+$(input).attr('id')+']').text()} cannot be empty</span>"

  getSum: ->
    counts =
      correct   : 0
      incorrect : 0
      missing   : 0
      total     : 0
      
    for input in @$el.find("input")
      $input = $(input)
      counts['correct']   += 1 if ($input.val()||"") != ""
      counts['incorrect'] += 0 if false
      counts['missing']   += 1 if ($input.val()||"") == ""
      counts['total']     += 1 if true

    return {
      correct   : counts['correct']
      incorrect : counts['incorrect']
      missing   : counts['missing']
      total     : counts['total']
    }
