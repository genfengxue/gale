express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

UserData = _u.getModel 'user_data'
WrapRequest = new (require '../../utils/WrapRequest')(UserData)
UserDataUtils = _u.getUtils 'user_data'

router.get '/', (req, res, next) ->
  WrapRequest.wrapIndex req, res, next

router.post "/multi", auth.isAuthenticated(), (req, res, next) ->
  UserDataUtils.buildDatas req.body, req.user.userNo
  .then (datas) ->
    UserData.createQ datas
  .then (docs) ->
    res.send docs
  .catch next
  .done()


module.exports = router
