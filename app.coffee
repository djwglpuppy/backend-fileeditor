devport = 9100
express = require("express")
RedisStore = require('connect-redis')(express)
stylus = require("stylus")


app = express.createServer(
    express.bodyParser(),
    express.cookieParser()
)

app.configure ->
    @set('views', __dirname + '/views')
    @set('view engine', 'jade')

app.configure "development", ->

    @use(require("coffee-middle")({
        src: __dirname + "/precompiled/js"
        dest: __dirname + "/static/js"
        browserReload: true
    }))

    @use(stylus.middleware({
        src: __dirname + "/precompiled"
        dest: __dirname + "/static"
        compress: true
    }))

    @use(express.static(__dirname + '/static'))
    @use(this.router)

app.configure "production", ->
    @use(express.static(__dirname + '/static'))
    @use(this.router)
    

require("./routes")(app)

if app.settings.env is "development"
    app.listen(devport)
    console.log "Started on port #{devport} in Development Mode"
else
    app.listen(9993)
    console.log "Started on port 9993 in Production Mode"