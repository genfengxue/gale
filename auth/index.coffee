express = require("express")
router = express.Router()

require './configure_passport'

router.get '/', (req, res) ->
  res.send hello: 'world'

module.exports = router
