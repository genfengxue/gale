express = require("express")
router = express.Router()

router.get "/", (req, res, next) ->
  res.send "keyPoint: #{req.query.id}"

module.exports = router
