express = require("express")
router = express.Router()

auth = require '../../auth/auth.service'
Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'
WrapRequest = new (require '../../utils/WrapRequest')(Sentence)
SentenceUtils = _u.getUtils 'sentence'

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.courseNo = ~~req.query.courseNo if req.query.courseNo
  conditions.lessonNo = ~~req.query.lessonNo if req.query.lessonNo
  conditions.sentenceNo = ~~req.query.sentenceNo if req.query.sentenceNo

  findParams =
    conditions: conditions
    options: {sort: {courseNo: 1, lessonNo: 1, sentenceNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams

#更新sentence中的key
router.patch '/:id/update_key/:keyId', auth.isAdmin(), (req, res, next) ->
  newKey = req.body.key
  conditions = {_id: req.params.id}
  Sentence.findOneQ conditions
  .then (sentence) ->
    _.each sentence.keyPoints, (keyPoint) ->
      if keyPoint._id.toString() is req.params.keyId
        loggerD.write {
          type: 'sentence_change_key'
          keyId: keyPoint._id
          from: keyPoint.key
          to: newKey
        }
        keyPoint.key = newKey

    sentence.saveQ()
  .then (doc) ->
    res.send doc
  .catch next
  .done()

#删除sentence中的key
router.patch '/:id/delete_key/:keyId', auth.isAdmin(), (req, res, next) ->
  sentenceId = req.params.id
  keyId = req.params.keyId

  Sentence.updateQ {_id: sentenceId}, {$pull: {keyPoints: {_id: keyId}}}
  .then (result) ->
    res.send result
  .catch next
  .done()


router.patch '/:id', auth.isAdmin(), (req, res, next) ->
  pickedUpdatedKeys = ['english', 'chinese']
  sentenceId = req.params.id
  conditions = _id: sentenceId
  WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys


#在sentence上新增知识点
router.post '/:id/new_key_point', auth.isAdmin(), (req, res, next) ->
  text = req.body.text
  key = req.body.key

  conditions = {_id: req.params.id}

  tmpResult = {}
  texts = [text] #接受一个text的数组
  SentenceUtils.importOneKey key, texts
  .then (keyPoint) ->
    tmpResult.keyPoint = keyPoint
    Sentence.findOneQ conditions
  .then (sentence) ->
    unless sentence
      return Q.reject
        status: 400
        errCode: ErrCode.CannotFindThisId
        errMsg: '无法找到这条记录'

    sentence.keyPoints.push tmpResult.keyPoint
    sentence.saveQ()
  .then (result) ->
    result[0].populateQ 'keyPoints.kps.kp'
  .then (doc) ->
    res.send doc
  .catch next
  .done()


module.exports = router
