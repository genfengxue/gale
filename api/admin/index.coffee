express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.lessonNo = req.query.lessonNo if req.query.lessonNo
  Sentence.findQ conditions, null, {sort: {lessonNo: 1, sentenceNo: 1}}
  .then (sentences) ->
    res.render 'index', {sentences: sentences}
  .catch next
  .done()

module.exports = router
