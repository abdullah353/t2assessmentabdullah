var ViewManager,
  __hasProp = Object.prototype.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

ViewManager = (function(_super) {

  __extends(ViewManager, _super);

  function ViewManager() {
    ViewManager.__super__.constructor.apply(this, arguments);
  }

  ViewManager.prototype.show = function(view) {
    var _ref,
      _this = this;
    window.scrollTo(0, 0);
    if ((_ref = this.currentView) != null) _ref.close();
    this.currentView = view;
    this.currentView.on("rendered", function() {
      var _base;
      $("#content").append(_this.currentView.el);
      _this.currentView.$el.find(".buttonset").buttonset();
      return typeof (_base = _this.currentView).afterRender === "function" ? _base.afterRender() : void 0;
    });
    this.currentView.on("subRendered", function() {
      return _this.currentView.$el.find(".buttonset").buttonset();
    });
    this.currentView.on("start_work", function() {
      return $("#content").prepend("<div id='loading_bar'><img class='loading' src='images/loading.gif'></div>");
    });
    this.currentView.on("end_work", function() {
      return $("#loading_bar").remove();
    });
    return this.currentView.render();
  };

  return ViewManager;

})(Backbone.View);
