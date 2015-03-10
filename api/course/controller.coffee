express = require("express")
router = express.Router()

Course = _u.getModel 'course'
WrapRequest = new (require '../../utils/WrapRequest')(Course)

router.get "/", (req, res, next) ->
  conditions = {}
  findParams =
    conditions: conditions
    options: {sort: {courseNo: 1}}

  WrapRequest.wrapIndex req, res, next, findParams

module.exports = router
