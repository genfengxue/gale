express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'
WrapRequest = new (require '../../utils/WrapRequest')(Sentence)

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.lessonNo = req.query.lessonNo if req.query.lessonNo
  WrapRequest.wrapIndex req, res, next, conditions

module.exports = router
