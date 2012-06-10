var ContentEditor, Main, main,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ContentEditor = (function(_super) {

  __extends(ContentEditor, _super);

  function ContentEditor() {
    return ContentEditor.__super__.constructor.apply(this, arguments);
  }

  ContentEditor.prototype.el = "#contenteditor";

  ContentEditor.prototype.current = "bio";

  ContentEditor.prototype.events = {
    "change [name='pagesel']": "changeEdit",
    "click .btn": "saveEdit"
  };

  ContentEditor.prototype.changeEdit = function(e) {
    this.current = this.$el.find("select option:selected").val();
    return this.pageedit();
  };

  ContentEditor.prototype.pageedit = function() {
    var _this = this;
    return $.get("/pageedit/" + this.current, function(content) {
      return _this.$el.find("textarea").val(content);
    });
  };

  ContentEditor.prototype.saveEdit = function() {
    return $.ajax({
      url: "/pageedit/" + this.current,
      data: {
        content: this.$el.find("textarea").val()
      },
      type: "PUT",
      complete: function() {
        return main.showAlert("Your page content has been saved");
      }
    });
  };

  ContentEditor.prototype.render = function() {
    var _this = this;
    _.each(_FILES, function(file) {
      return _this.$el.find("[name='pagesel']").append("<option value='" + file + "'>" + file + "</option>");
    });
    this.current = _FILES[0];
    return this.pageedit();
  };

  return ContentEditor;

})(Backbone.View);

Main = (function(_super) {

  __extends(Main, _super);

  function Main() {
    return Main.__super__.constructor.apply(this, arguments);
  }

  Main.prototype.el = "body";

  Main.prototype.showAlert = function(msg) {
    return $("#alert").html(msg).slideDown(300, function() {
      return _.delay((function() {
        return $("#alert").slideUp(200);
      }), 4000);
    });
  };

  Main.prototype.start = function() {
    return new ContentEditor().render();
  };

  return Main;

})(Backbone.View);

main = new Main;

$(function() {
  return main.start();
});
