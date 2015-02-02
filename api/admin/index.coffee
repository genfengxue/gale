express = require("express")
router = express.Router()

router.get "/", (req, res, next) ->
  res.render 'index', {good: 5}

module.exports = router
