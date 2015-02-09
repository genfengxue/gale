express = require("express")
router = express.Router()

KeyPoint = _u.getModel 'key_point'
WrapRequest = new (require '../../utils/WrapRequest')(KeyPoint)

router.get "/", (req, res, next) ->
  WrapRequest.wrapIndex req, res, next, {}

module.exports = router
