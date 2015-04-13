require '../common/init'

ReleaseNote = _u.getModel 'release_note'

data =
  version: 'v0.3.9.1'
  content: """
  1. 增加了新概念71-143
  2. 直捷英语导入部分知识点，开始使用知识点功能
  3. 去掉了某些使用价值较低的功能
  """
  created: '2015-04-10'

ReleaseNote.createQ data
.then (doc) ->
  console.log doc
, (err) ->
  logger.info err
