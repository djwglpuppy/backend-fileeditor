class ContentEditor extends Backbone.View
	el: "#contenteditor"
	current: "bio"
	events: 
		"change [name='pagesel']": "changeEdit"
		"click .btn": "saveEdit"

	changeEdit: (e) ->
		@current = @$el.find("select option:selected").val()
		@pageedit()

	pageedit: -> $.get "/pageedit/#{@current}", (content) =>
		@$el.find("textarea").val(content)

	saveEdit: ->
		$.ajax
			url: "/pageedit/#{@current}" 
			data: {content: @$el.find("textarea").val()}
			type: "PUT"
			complete: -> main.showAlert("Your page content has been saved")

	render: -> 
		_.each _FILES, (file) => @$el.find("[name='pagesel']").append("<option value='#{file}'>#{file}</option>")
		@current = _FILES[0]
		@pageedit()

class Main extends Backbone.View
	el: "body"
	showAlert: (msg) ->
		$("#alert")
		.html(msg)
		.slideDown 300, -> _.delay((-> $("#alert").slideUp(200)), 4000)
	start: ->
		new ContentEditor().render()

main = new Main
$ -> main.start()