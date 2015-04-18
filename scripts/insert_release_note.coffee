require '../common/init'

ReleaseNote = _u.getModel 'release_note'

data =
  versionCode: 1
  versionName: 'v0.3.9.1'
  content: """
  1. this is v0.3.9.1
  """
  releaseDate: '2015-04-10'
  created: new Date()

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
