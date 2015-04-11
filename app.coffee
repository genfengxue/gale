require './common/init'
express = require 'express'
morgan = require 'morgan'
favicon = require 'serve-favicon'
passport = require 'passport'
path = require 'path'
bodyParser = require 'body-parser'
cookieParser = require('cookie-parser')

app = express()

app.use((req, res, next) ->
  if req.hostname is '123.249.24.233' #block host because of scanning port
    console.log "what's this?"
    res.sendStatus 404
  else
    next()
)

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: false}))
app.use(cookieParser())
app.use(passport.initialize())

app.use(favicon(__dirname + '/public/favicon.ico'))

fs = require 'fs'
accessLog = fs.createWriteStream(config.morgan.accessLog, { flags: 'a' })
errorLog = fs.createWriteStream(config.morgan.errorLog, { flags: 'a' })
app.use(morgan('combined', {stream: accessLog}))
app.use(morgan('dev'))

app.use(express.static(path.join(__dirname, 'public')))
#app.use(express.static(path.join(__dirname, 'client')))

app.use((req, res, next) ->
  res.header('Access-Control-Allow-Origin', '*')
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE,OPTION,PATCH')
  res.header('Access-Control-Allow-Headers', 'Content-Type,Authorization')

  next()
)

app.set('views', __dirname + '/views')
app.set('view engine', 'ejs')

app.use((req, res, next) ->
  logger.info "host: #{req.hostname}, method: #{req.method}, url: #{req.url}"
  next()
)

app.get('/', (req, res, next) ->
  res.send({hello: 'girlfriend'})
  next()
)

require('./routes')(app)

app.use((err, req, res, next) ->
  meta = '[' + new Date() + '] ' + req.url + '\n'
  if (err)
    errorLog.write(meta + err.stack + '\n')
    logger.error(err)
  next()
)

server = app.listen(config.port, () ->

  host = server.address().address
  port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)
)
