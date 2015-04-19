require '../common/init'

ReleaseNote = _u.getModel 'release_note'

data =
  versionCode: 2
  versionName: 'v0.4'
  content: """
  1. this is v0.4
  """
  releaseDate: '2015-04-19'
  created: new Date()

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
