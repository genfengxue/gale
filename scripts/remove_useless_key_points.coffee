require '../common/init'

Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'

kpIds = []
Sentence.findQ {}
.then (sentences) ->
  console.log sentences
  _.each sentences, (sentence) ->
    _.each sentence.keyPoints, (keyPoint) ->
      kpIds = kpIds.concat(_.pluck keyPoint.kps, 'kp')

  loggerD.write {type: 'remain_kp', kpIds: kpIds}
  KeyPoint.removeQ {_id: {$nin: kpIds}}
.then () ->
  loggerD.write "remove useless kp: success"
, (err) ->
  logger.info err
