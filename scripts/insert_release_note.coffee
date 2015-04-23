require '../common/init'

ReleaseNote = _u.getModel 'release_note'

versionName = 'v1.0.2'
data =
  versionCode: 7
  versionName: versionName
  content: """
  #{versionName}
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
