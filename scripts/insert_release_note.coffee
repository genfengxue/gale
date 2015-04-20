require '../common/init'

ReleaseNote = _u.getModel 'release_note'

data =
  versionCode: 3
  versionName: 'v0.9'
  content: """
  1 这是0.9版本，等待1.0的出现
  """
  releaseDate: '2015-04-20'
  created: new Date()

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
