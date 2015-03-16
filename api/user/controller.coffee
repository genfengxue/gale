express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

User = _u.getModel 'user'
WrapRequest = new (require '../../utils/WrapRequest')(User)

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.courseNo = req.query.courseNo if req.query.courseNo
  findParams =
    conditions: conditions
    options: {sort: {sentenceNo: 1, lessonNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams

module.exports = router
