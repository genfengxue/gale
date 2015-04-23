require '../common/init'

ReleaseNote = _u.getModel 'release_note'

versionName = 'v1.0.3'
data =
  versionCode: 8
  versionName: versionName
  content: """
  #{versionName}
  现在终于可以优雅地退出了，不用点半天了
  """
  releaseDate: '2015-04-23'
  created: new Date()

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
