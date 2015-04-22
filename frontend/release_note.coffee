express = require("express")
router = express.Router()

ReleaseNote = _u.getModel 'release_note'

router.get "/", (req, res, next) ->
  ReleaseNote.findQ {}, null, {sort: {versionCode: -1}}
  .then (releaseNotes) ->
    res.render 'release_notes', {releaseNotes: releaseNotes}
  .catch next
  .done()

module.exports = router
