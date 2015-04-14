express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

ReleaseNote = _u.getModel 'release_note'
WrapRequest = new (require '../../utils/WrapRequest')(ReleaseNote)

router.get "/latest", (req, res, next) ->
  ReleaseNote.findOneQ {}, null, {sort: {releaseDate: -1}}
  .then (doc) ->
    res.send
      version: doc.version
      url: _s.sprintf config.apkUrl, doc.version.substr 1

module.exports = router
