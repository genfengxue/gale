require '../common/init'

ReleaseNote = _u.getModel 'release_note'

versionName = 'v1.0.4'
data =
  versionCode: 9
  versionName: versionName
  content: """
  #{versionName}
  1 返回列表时回到上次操作的位置
  2 下载失败时打印更多的信息
  """
  releaseDate: '2015-05-06'
  created: new Date()

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
  process.exit 0
, (err) ->
  logger.info err
  process.exit 1
