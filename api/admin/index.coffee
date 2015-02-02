express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'

router.get "/", (req, res, next) ->
  Sentence.findAllQ()
  .then (sentences) ->
    res.render 'index', {sentences: sentences}
  .catch next
  .done()

module.exports = router
