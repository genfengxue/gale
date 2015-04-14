module.exports =
  hello: 'girlfriend'
  appName: 'gale'
  port: 9000
  morgan:
    accessLog: '/data/log/gale.access.log'
    errorLog : '/data/log/gale.error.log'
  mongo:
    uri: 'mongodb://localhost/gale'
  secrets:
    session: process.env.EXPRESS_SECRET or 'gale-secret'
  tokenExpiresInMinutes: 60 * 24 * 7
  qiniuUrl: 'http://7u2qm8.com1.z0.glb.clouddn.com'
  apkUrl: 'http://7u2qm8.com1.z0.glb.clouddn.com/apk/LearnWithWind%s.apk'
