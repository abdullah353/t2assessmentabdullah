var Result,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

Result = (function(_super) {

  __extends(Result, _super);

  function Result() {
    Result.__super__.constructor.apply(this, arguments);
  }

  Result.prototype.url = "result";

  Result.prototype.initialize = function(options) {
    if (options.blank === true) {
      this.set({
        'subtestData': [],
        'start_time': (new Date()).getTime(),
        'enumerator': Tangerine.user.name
      });
      return this.unset("blank");
    }
  };

  Result.prototype.add = function(subtestDataElement) {
    var subtestData;
    subtestData = this.get('subtestData');
    subtestData['timestamp'] = (new Date()).getTime();
    subtestData.push(subtestDataElement);
    return this.save({
      'subtestData': subtestData
    });
  };

  Result.prototype.getGridScore = function(id) {
    var datum, _i, _len, _ref;
    _ref = this.get('subtestData');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      datum = _ref[_i];
      if (datum.subtestId === id) return parseInt(datum.data.attempted);
    }
  };

  Result.prototype.gridWasAutostopped = function(id) {
    var datum, _i, _len, _ref;
    _ref = this.get('subtestData');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      datum = _ref[_i];
      if (datum.subtestId === id) return datum.data.auto_stop;
    }
  };

  return Result;

})(Backbone.Model);
