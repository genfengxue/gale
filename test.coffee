require './common/init'
KeyPoint = _u.getModel 'key_point'
KeyPoint.create {title: 'xxxx', text: '这是第一个知识点'}, (err, doc) ->
  logger.info err, doc
