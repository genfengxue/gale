express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'
WrapRequest = new (require '../../utils/WrapRequest')(Sentence)

router.get "/", (req, res, next) ->
  WrapRequest.wrapIndex req, res, next, {}

module.exports = router
