// Generated by CoffeeScript 1.6.3
var Results, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Results = (function(_super) {
  __extends(Results, _super);

  function Results() {
    _ref = Results.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Results.prototype.url = "result";

  Results.prototype.model = Result;

  Results.prototype.db = {
    view: "resultsByAssessmentId"
  };

  Results.prototype.initialize = function() {};

  Results.prototype.comparator = function(model) {
    return model.get('timestamp') || 0;
  };

  return Results;

})(Backbone.Collection);
