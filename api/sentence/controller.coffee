express = require("express")
router = express.Router()

auth = require '../../auth/auth.service'
Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'
WrapRequest = new (require '../../utils/WrapRequest')(Sentence)

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.courseNo = ~~req.query.courseNo if req.query.courseNo
  conditions.lessonNo = ~~req.query.lessonNo if req.query.lessonNo

  findParams =
    conditions: conditions
    options: {sort: {courseNo: 1, lessonNo: 1, sentenceNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams


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


router.patch '/:id/new_key_point', auth.isAdmin(), (req, res, next) ->
  text = req.body.text
  key = req.body.key
  kp =
    text: text

  conditions = {_id: req.params.id}

  KeyPoint.createQ kp
  .then (doc) ->
    Sentence.findOneQ conditions
  .then (sentence) ->
    console.log "TODO"


module.exports = router
