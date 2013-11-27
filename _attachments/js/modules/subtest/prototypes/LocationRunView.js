// Generated by CoffeeScript 1.6.3
var LocationRunView, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

LocationRunView = (function(_super) {
  __extends(LocationRunView, _super);

  function LocationRunView() {
    _ref = LocationRunView.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  LocationRunView.prototype.events = {
    "click .school_list li": "autofill",
    "click .school_list li.licomp": "licomp",
    "click .school_list li.lipend": "lipend",
    "keyup input.search": "showOptions",
    "click .clear": "clearInputs"
  };

  LocationRunView.prototype.initialize = function(options) {
    var control, control1, i, level, location, locationData, template, _i, _j, _k, _len, _len1, _len2, _ref1, _ref2,
      _this = this;
    this.pendResAr = [];
    this.compResAr = [];
    this.penNam = [];
    this.penkeys = [];
    this.compNam = [];
    this.samAssessmentId = options.parent.model.attributes.assessmentId;
    this.resultarray = new Results;
    this.resultarray.fetch({
      "_id": this.samAssessmentId,
      success: function(gotresult) {
        _.each(gotresult.models, function(result3) {
          var alreadyExist, _ref1;
          if (((_ref1 = _.last(result3.attributes.subtestData)) != null ? _ref1.data.end_time : void 0) != null) {
            return _this.compResAr.push(result3.attributes.subtestData);
          } else {
            _this.pendResAr.push(result3.attributes.subtestData);
            if (_this.penkeys.length === 0) {
              _this.penkeys.push(result3.id);
            }
            alreadyExist = false;
            _.each(_this.penkeys, function(penkey) {
              if (penkey !== result3.id) {
                return alreadyExist = true;
              }
            });
            if (alreadyExist) {
              return _this.penkeys.push(result3.id);
            }
          }
        });
        _.each(_this.pendResAr, function(items) {
          return _.each(items, function(item) {
            var _ref1;
            if (((item != null ? item.prototype : void 0) != null) && item.prototype === "location" && (((_ref1 = item.data) != null ? _ref1.location : void 0) != null)) {
              return _this.penNam.push(item.data.location);
            }
          });
        });
        return _.each(_this.compResAr, function(items) {
          return _.each(items, function(item) {
            var _ref1;
            if (((item != null ? item.prototype : void 0) != null) && item.prototype === "location" && (((_ref1 = item.data) != null ? _ref1.location : void 0) != null)) {
              return _this.compNam.push(item.data.location);
            }
          });
        });
      }
    });
    this.model = this.options.model;
    this.parent = this.options.parent;
    this.levels = this.model.get("levels") || [];
    this.locations = this.model.get("locations") || [];
    if (this.levels.length === 1 && this.levels[0] === "") {
      this.levels = [];
    }
    if (this.locations.length === 1 && this.locations[0] === "") {
      this.locations = [];
    }
    this.haystack = [];
    this.locations = this.locations.sort();
    _ref1 = this.locations;
    for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
      location = _ref1[i];
      this.haystack[i] = [];
      for (_j = 0, _len1 = location.length; _j < _len1; _j++) {
        locationData = location[_j];
        this.haystack[i].push(locationData.toLowerCase());
      }
    }
    template = "<li class='cont' data-index='{{i}}'>";
    _ref2 = this.levels;
    for (i = _k = 0, _len2 = _ref2.length; _k < _len2; i = ++_k) {
      level = _ref2[i];
      template += "{{level_" + i + "}}";
      if (i !== this.levels.length - 1) {
        template += " - ";
      }
    }
    template += "</li>";
    this.li = _.template(template);
    control = '<button class="restart-btn navigation">Restart</button>';
    this.btnreset = _.template(control);
    control1 = '<button class="resume-btn navigation">Resume</button>';
    return this.btnresume = _.template(control1);
  };

  LocationRunView.prototype.clearInputs = function() {
    var i, level, _i, _len, _ref1, _results;
    this.clearMessage();
    this.clearButton();
    _ref1 = this.levels;
    _results = [];
    for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
      level = _ref1[i];
      _results.push(this.$el.find("#level_" + i).val(""));
    }
    return _results;
  };

  LocationRunView.prototype.autofill = function(event) {
    var i, index, level, location, _i, _len, _ref1, _results;
    this.clearMessage();
    this.clearButton();
    this.$el.find(".autofill").fadeOut(250);
    index = $(event.target).attr("data-index");
    location = this.locations[index];
    _ref1 = this.levels;
    _results = [];
    for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
      level = _ref1[i];
      _results.push(this.$el.find("#level_" + i).val(location[i]));
    }
    return _results;
  };

  LocationRunView.prototype.showOptions = function(event) {
    var atLeastOne, field, html, i, isThere, j, needle, otherField, result, results, stack, _i, _j, _k, _l, _len, _len1, _len2, _len3, _m, _ref1, _ref2, _ref3;
    this.clearMessage();
    needle = $(event.target).val().toLowerCase();
    if (needle === '') {
      return $('.autofill').hide();
    } else {
      field = parseInt($(event.target).attr('data-level'));
      for (otherField = _i = 0, _ref1 = this.haystack.length; 0 <= _ref1 ? _i <= _ref1 : _i >= _ref1; otherField = 0 <= _ref1 ? ++_i : --_i) {
        this.$el.find("#autofill_" + otherField).hide();
      }
      atLeastOne = false;
      results = [];
      _ref2 = this.haystack;
      for (i = _j = 0, _len = _ref2.length; _j < _len; i = ++_j) {
        stack = _ref2[i];
        isThere = ~this.haystack[i][field].indexOf(needle);
        if (isThere) {
          results.push(i);
        }
        if (isThere) {
          atLeastOne = true;
        }
      }
      _ref3 = this.haystack;
      for (i = _k = 0, _len1 = _ref3.length; _k < _len1; i = ++_k) {
        stack = _ref3[i];
        for (j = _l = 0, _len2 = stack.length; _l < _len2; j = ++_l) {
          otherField = stack[j];
          if (j === field) {
            continue;
          }
          isThere = ~this.haystack[i][j].indexOf(needle);
          if (isThere && !~results.indexOf(i)) {
            results.push(i);
          }
          if (isThere) {
            atLeastOne = true;
          }
        }
      }
      if (atLeastOne) {
        html = "";
        for (_m = 0, _len3 = results.length; _m < _len3; _m++) {
          result = results[_m];
          html += this.getLocationLi(result);
        }
        this.$el.find("#autofill_" + field).fadeIn(250);
        return this.$el.find("#school_list_" + field).html(html);
      } else {
        return this.$el.find("#autofill_" + field).fadeOut(250);
      }
    }
  };

  LocationRunView.prototype.getLocationLi = function(i) {
    var abc, j, location, templateInfo, _i, _len, _ref1,
      _this = this;
    templateInfo = {
      "i": i
    };
    _ref1 = this.locations[i];
    for (j = _i = 0, _len = _ref1.length; _i < _len; j = ++_i) {
      location = _ref1[j];
      templateInfo["level_" + j] = location;
      abc = this.li(templateInfo);
      _.each(this.penNam, function(pendingname, i) {
        var a;
        a = [];
        a.push(location);
        if (_.isEqual(a, pendingname)) {
          return abc = abc.replace("<li class='cont'", "<li class='lipend' style='color:red;' data-key='" + _this.penkeys[i] + "' ");
        }
      });
      _.each(this.compNam, function(completename) {
        var a;
        a = [];
        a.push(location);
        if (_.isEqual(a, completename)) {
          return abc = abc.replace("<li class='cont'", "<li class='licomp' style='color:green;'");
        }
      });
    }
    return abc;
  };

  LocationRunView.prototype.render = function() {
    var html, i, level, schoolListElements, _i, _len, _ref1;
    schoolListElements = "";
    html = "      <button class='clear command'>Clear</button>      ";
    _ref1 = this.levels;
    for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
      level = _ref1[i];
      html += "        <div class='label_value'>          <label for='level_" + i + "'>" + level + "</label><br>          <input class='search' val='' data-level='" + i + "' id='samSearchBox' placeholder='Search For Student Name'>          <label>Selected Student Name: </label>          <input class='name-field' data-level='" + i + "' id='level_" + i + "' value='' disabled>        </div>        <div id='autofill_" + i + "' class='autofill' style='display:none'>          <h2>Select one from autofill list</h2>          <ul class='school_list' id='school_list_" + i + "'>          </ul>        </div>    ";
    }
    this.$el.html(html);
    return this.trigger("rendered");
  };

  LocationRunView.prototype.getResult = function() {
    var i, level;
    return {
      "labels": (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.levels;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          level = _ref1[_i];
          _results.push(level.replace(/[\s-]/g, "_"));
        }
        return _results;
      }).call(this),
      "location": (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.levels;
        _results = [];
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          level = _ref1[i];
          _results.push($.trim(this.$el.find("#level_" + i).val()));
        }
        return _results;
      }).call(this)
    };
  };

  LocationRunView.prototype.getSkipped = function() {
    var i, level;
    return {
      "labels": (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.levels;
        _results = [];
        for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
          level = _ref1[_i];
          _results.push(level.replace(/[\s-]/g, "_"));
        }
        return _results;
      }).call(this),
      "location": (function() {
        var _i, _len, _ref1, _results;
        _ref1 = this.levels;
        _results = [];
        for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
          level = _ref1[i];
          _results.push("skipped");
        }
        return _results;
      }).call(this)
    };
  };

  LocationRunView.prototype.isValid = function() {
    var input, _i, _len, _ref1;
    this.$el.find(".message").remove();
    _ref1 = this.$el.find("input");
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      input = _ref1[_i];
      if ($(input).val() === "") {
        return false;
      }
    }
    return true;
  };

  LocationRunView.prototype.showErrors = function() {
    var input, _i, _len, _ref1, _results;
    _ref1 = this.$el.find("input.name-field");
    _results = [];
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      input = _ref1[_i];
      if ($(input).val() === "") {
        _results.push($(input).after(" <span class='message' style='color:red'>Please select a student to proceed.</span>"));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  LocationRunView.prototype.getSum = function() {
    var $input, counts, input, _i, _len, _ref1;
    counts = {
      correct: 0,
      incorrect: 0,
      missing: 0,
      total: 0
    };
    _ref1 = this.$el.find("input");
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      input = _ref1[_i];
      $input = $(input);
      if (($input.val() || "") !== "") {
        counts['correct'] += 1;
      }
      if (false) {
        counts['incorrect'] += 0;
      }
      if (($input.val() || "") === "") {
        counts['missing'] += 1;
      }
      if (true) {
        counts['total'] += 1;
      }
    }
    return {
      correct: counts['correct'],
      incorrect: counts['incorrect'],
      missing: counts['missing'],
      total: counts['total']
    };
  };

  LocationRunView.prototype.licomp = function(e) {
    $("button.next").hide();
    if ($("button.restart-btn").length === 0) {
      $('div.controlls').append(this.btnreset);
    } else {
      $("button.restart-btn").show();
    }
    return $("button.restart-btn").unbind("click").click(function() {
      if (confirm("Are you sure you want to restart this assessment?")) {
        return $("button.next").trigger("click");
      }
    });
  };

  LocationRunView.prototype.lipend = function(event) {
    var index, key, _ref1, _ref2, _ref3, _ref4,
      _this = this;
    if ((event != null ? (_ref1 = event.currentTarget) != null ? (_ref2 = _ref1.dataset) != null ? _ref2.key : void 0 : void 0 : void 0) != null) {
      key = event.currentTarget.dataset.key;
    }
    if ((event != null ? (_ref3 = event.currentTarget) != null ? (_ref4 = _ref3.dataset) != null ? _ref4.index : void 0 : void 0 : void 0) != null) {
      index = event.currentTarget.dataset.index;
    }
    this.licomp();
    if ($("button.resume-btn").length === 0) {
      $('div.controlls').append(this.btnresume);
    } else {
      $("button.resume-btn").show();
    }
    return $("button.resume-btn").unbind("click").click(function() {
      return Tangerine.router.navigate("resume/" + _this.samAssessmentId + "/" + key, true);
    });
  };

  LocationRunView.prototype.clearButton = function() {
    $('button.restart-btn').hide();
    $('button.resume-btn').hide();
    return $('button.next').show();
  };

  LocationRunView.prototype.clearMessage = function() {
    return $('span.message').hide();
  };

  return LocationRunView;

})(Backbone.View);
