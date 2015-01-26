module.exports =
  hello: 'girlfriend'
  appName: 'gale'
  port: 9000
  morgan:
    accessLog: '/data/log/gale.log'
    errorLog : '/data/log/error.log'
  mongo:
    uri: 'mongodb://localhost/gale'
