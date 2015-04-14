require '../common/init'

ReleaseNote = _u.getModel 'release_note'

data =
  version: 'v1.3.9.2'
  content: """
  1. this is v1.3.9.2
  """
  releaseDate: '2015-04-15'

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
