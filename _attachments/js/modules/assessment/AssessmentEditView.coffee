class AssessmentEditView extends Backbone.View

  className : 'assessment_edit_view'

  events :
    'click #archive_buttons input' : 'save'
    'click .back'                  : 'back'
    'click .new_subtest_button'    : 'toggleNewSubtestForm'
    'click .new_subtest_cancel'    : 'toggleNewSubtestForm'

    'keypress #new_subtest_name'   : 'saveNewSubtest'
    'click .new_subtest_save'      : 'saveNewSubtest'

    'keypress #basic input'        : 'showSave'
    'click .assessment_save'       : 'save'

    'click .save'                  : 'save'

  
  save: =>
    if @updateModel()
      if @model.save(null, {wait:true}) 
        Utils.midAlert "Assessment saved" 
        Tangerine.router.navigate "edit/"+@model.id, true
        @hideSave()

  showSave: -> @$el.find('.assessment_save').fadeIn(250)
  
  hideSave: -> @$el.find('.assessment_save').fadeToggle(250)
  
  back: ->
    Tangerine.router.navigate "assessments/#{@model.get("group")}", true

  updateModel: =>

    # parse acceptable random sequences
    sequencesValue = $.trim(@$el.find("#sequences").val())
    sequences = sequencesValue.split("\n")

    for sequence, i in sequences
      sequence = sequence.split(",")
      for element, j in sequence
        sequence[j] = parseInt(element)
      sequences[i] = sequence
      
      # detect errors
      tooManyError = true if sequence.length > @model.subtests.models.length
      tooFewError  = true if sequence.length < @model.subtests.models.length
      doublesError = true if sequence.length != _.uniq(sequence).length
    
    # show errors if they exist
    sequenceErrors = []
    if tooManyError then sequenceErrors.push "Some sequences are longer than the total number of all subtests."
    if tooFewError  then sequenceErrors.push "Some sequences are shorter than the total number of all subtests."
    if doublesError then sequenceErrors.push "Some sequences contain doubles."
    if sequenceErrors.length != 0
      alert "Warning\n\n#{sequenceErrors.join("\n")}"
  

    # wow, I have no idea what this does. This code is really old.
    groups = Tangerine.user.get("groups")
    if not ~groups.indexOf(@$el.find("#assessment_group").val())
      alert "Warning\n\nYou cannot join a group unless you are a member of that group."
      @$el.find("#assessment_group").val @model.escape "group"
      @hideSave()
      return false
    else
      @model.set
        sequences : sequences
        archived  : @$el.find("#archive_buttons input:checked").val() == "true"
        name      : @$el.find("#assessment_name").val()
        group     : @$el.find("#assessment_group").val()
        dKey      : @$el.find("#assessment_d_key").val()
        assessmentId : @model.id
      return true

  toggleNewSubtestForm: (event) ->
    @$el.find(".new_subtest_form, .new_subtest_button").fadeToggle(250, => 
      @$el.find("#new_subtest_name").val("")
      @$el.find("#subtest_type_select").val("none")
    )
    false

  saveNewSubtest: (event) =>
    
    if event.type != "click" && event.which != 13
      return true
    
    # general template
    newAttributes = Tangerine.templates.subtestTemplate
    
    # prototype template
    prototypeTemplate = Tangerine.templates.prototypeTemplates[@$el.find("#subtest_type_select").val()]
    
    # bit more specific template
    useType = @$el.find("#subtest_type_select :selected").attr 'data-template'
    useTypeTemplate = Tangerine.templates.subtestTemplates[@$el.find("#subtest_type_select").val()][useType]

    newAttributes = $.extend newAttributes, prototypeTemplate
    newAttributes = $.extend newAttributes, useTypeTemplate
    newAttributes = $.extend newAttributes,
      name         : @$el.find("#new_subtest_name").val()
      assessmentId : @model.id
      order        : @model.subtests.length
    newSubtest = @model.subtests.create newAttributes
    @toggleNewSubtestForm()
    return false
  
  
  initialize: (options) ->
    @model = options.model
    @subtestListEditView = new SubtestListEditView
      "assessment" : @model

    @model.subtests.on "change remove", @subtestListEditView.render
    @model.subtests.on "all", @updateSubtestLegend

  render: =>
    sequences = ""
    if @model.has("sequences") 
      sequences = @model.get("sequences")
      sequences = sequences.join("\n")

      if _.isArray(sequences)
        for sequences, i in sequences 
          sequences[i] = sequences.join(", ")

    subtestLegend = @updateSubtestLegend()

    arch = @model.get('archived')
    archiveChecked    = if (arch == true or arch == 'true') then "checked" else ""
    notArchiveChecked = if archiveChecked then "" else "checked"

    # list of "templates"
    subtestTypeSelect = "<select id='subtest_type_select'>
      <option value='none' disabled='disabled' selected='selected'>Please select a subtest type</option>"
    for key, value of Tangerine.templates.subtestTemplates
      subtestTypeSelect += "<optgroup label='#{key}'>"
      for subKey, subValue of value
        subtestTypeSelect += "<option value='#{key}' data-template='#{subKey}'>#{subKey}</option>"
      subtestTypeSelect += "</optgroup>"
    subtestTypeSelect += "</select>"

    
    @$el.html "
      <button class='back navigation'>Back</button>
        <h1>Assessment Builder</h1>
      <div id='basic'>
        <label for='assessment_name'>Name</label>
        <input id='assessment_name' value='#{@model.escape("name")}'>

        <label for='assessment_group'>Group</label>
        <input id='assessment_group' value='#{@model.escape("group")}'>

        <button class='assessment_save confirmation'>Save</button><br>

        <label for='assessment_d_key' title='This key is used to import the assessment from a tablet'>Download Key</label><br>
        <div class='info_box'>#{@model.id.substr(-5,5)}</div>
      </div>

      <label title='Only active assessments will be displayed in the main assessment list.'>Status</label><br>
      <div id='archive_buttons' class='buttonset'>
        <input type='radio' id='archive_false' name='archive' value='false' #{notArchiveChecked}><label for='archive_false'>Active</label>
        <input type='radio' id='archive_true'  name='archive' value='true'  #{archiveChecked}><label for='archive_true'>Archived</label>
      </div>
      <h2>Subtests</h2>
      <div class='menu_box'>
        <div>
        <ul id='subtest_list'>
        </ul>
        </div>
        <button class='new_subtest_button command'>Add Subtest</button>
        <div class='new_subtest_form confirmation'>
          <div class='menu_box'>
            <h2>New Subtest</h2>
            <label for='subtest_type_select'>Type</label><br>
            #{subtestTypeSelect}<br>
            <label for='new_subtest_name'>Name</label><br>
            <input type='text' id='new_subtest_name'>
            <button class='new_subtest_save command'>Add</button> <button class='new_subtest_cancel command'>Cancel</button>
          </div>
        </div>
      </div>
      <h2>Options</h2>
      <div class='label_value'>
        <label for='sequences' title='This is a list of acceptable orders of subtests, which will be randomly selected each time an assessment is run. Subtest indicies are separated by commas, new lines separate sequences. '>Random Sequences</label>
        <div id='subtest_legend'>#{subtestLegend}</div>
        <textarea id='sequences'>#{sequences}</textarea>
      </div>
      <button class='save command'>Save</button>
      "

    # render new subtest views
    @subtestListEditView.setElement(@$el.find("#subtest_list"))
    @subtestListEditView.render()
    
    # make it sortable
    @$el.find("#subtest_list").sortable
      handle : '.sortable_handle'
      start: (event, ui) -> ui.item.addClass "drag_shadow"
      stop:  (event, ui) -> ui.item.removeClass "drag_shadow"
      update : (event, ui) =>
        for id, i in ($(li).attr("data-id") for li in @$el.find("#subtest_list li"))
          @model.subtests.get(id).set({"order":i},{silent:true}).save(null,{silent:true})
        @model.subtests.sort()

    @trigger "rendered"

  
  updateSubtestLegend: =>
    subtestLegend = ""
    @model.subtests.each (subtest, i) ->
      subtestLegend += "<div class='small_grey'>#{i} - #{subtest.get("name")}</div><br>"
    $subtestWrapper = @$el.find("#subtest_legend")
    $subtestWrapper.html(subtestLegend) if $subtestWrapper.length != 0
    return subtestLegend

  onClose: ->
    @subtestListEditView.close()
    