require './common/init'
express = require 'express'
morgan = require 'morgan'
favicon = require 'serve-favicon'
passport = require 'passport'
path = require 'path'
bodyParser = require 'body-parser'
cookieParser = require('cookie-parser')

console.log config

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
app.set('views', __dirname + '/views')
app.set('view engine', 'ejs')

app.use((req, res, next) ->
  if /^yang/.test(req.hostname)
    req.url = '/yang'

  logger.info "host: #{req.hostname}, method: #{req.method}, url: #{req.url}"
  next()
)

app.get('/', (req, res, next) ->
  res.send('hello girlfriend!')
  next()
)

global.count = 0
app.get('/yang', (req, res) ->
  res.send("洋洋，这是你第#{++global.count}次来看我的网站")
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
