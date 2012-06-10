fs = require("fs")
_ = require("underscore")

files = {}
editablefiles = fs.readdirSync(process.env.FOLDER_DIR)
_.each editablefiles, (file) -> files[file] = process.env.FOLDER_DIR + "/" + file

module.exports = (app) ->
	app.get '/', (req, res) -> res.render 'index',
		title: 'EtymOnline Site Administration'
		files: editablefiles

	app.get "/pageedit/:page", (req, res) ->
		file = files[req.params.page]
		if file?
			fs.readFile files[req.params.page], 'utf8', (e, d) -> res.send(d)
		else
			res.send("This is not the file you are looking for")


	app.put "/pageedit/:page", (req, res) ->
		file = files[req.params.page]
		fs.writeFile(files[req.params.page], req.body.content, -> res.send("success")) if file?