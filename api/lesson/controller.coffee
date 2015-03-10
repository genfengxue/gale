express = require("express")
router = express.Router()

Lesson = _u.getModel 'lesson'
WrapRequest = new (require '../../utils/WrapRequest')(Lesson)

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.courseNo = req.query.courseNo if req.query.courseNo
  findParams =
    conditions: conditions
    options: {sort: {sentenceNo: 1, lessonNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams

module.exports = router
