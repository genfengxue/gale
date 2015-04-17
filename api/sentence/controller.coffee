express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'
WrapRequest = new (require '../../utils/WrapRequest')(Sentence)

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.courseNo = req.query.courseNo if req.query.courseNo
  conditions.lessonNo = req.query.lessonNo if req.query.lessonNo
  # 这几行代码是有问题的，未来会被删掉，主要是为了兼容vita之前拿数据的方式，courseNo为1的时候，他把所有的lessonNo加了300
  courseNo = ~~conditions.courseNo
  lessonNo = ~~conditions.lessonNo
  if courseNo is 1 and lessonNo > 0 and lessonNo < 300
    conditions.lessonNo = lessonNo + 300

  findParams =
    conditions: conditions
    options: {sort: {courseNo: 1, lessonNo: 1, sentenceNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams

module.exports = router
