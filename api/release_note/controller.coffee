express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

ReleaseNote = _u.getModel 'release_note'
WrapRequest = new (require '../../utils/WrapRequest')(ReleaseNote)

router.get "/latest", (req, res, next) ->
  ReleaseNote.findOneQ {}, null, {sort: {releaseDate: -1}}
  .then (doc) ->
    res.send
      versionCode: doc.versionCode
      versionName: doc.versionName
      url: _s.sprintf config.apkUrl, doc.versionName.substr 1
  .catch next
  .done()

module.exports = router
