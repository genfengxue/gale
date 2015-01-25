require './common/init'
express = require 'express'

console.log config

app = express()

server = app.listen(config.port, () ->

  host = server.address().address
  port = server.address().port

  console.log('Example app listening at http://%s:%s', host, port)
)

app.get('/', (req, res) ->
  res.send('hello girlfriend!')
)
