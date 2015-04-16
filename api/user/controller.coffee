express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

User = _u.getModel 'user'
UserUtils = _u.getUtils 'user'
WrapRequest = new (require '../../utils/WrapRequest')(User)

router.post "/change_password", auth.isAuthenticated(), (req, res, next) ->
  userNo = req.user.userNo
  oldPass = req.body.oldPassword
  newPass = req.body.newPassword

  user = req.user

  if user.authenticate oldPass
    user.password = newPass
    user.saveQ()
    .then (result) ->
      logger.info result
      res.sendStatus 200
    , (err) ->
      logger.info err
  else
    res.sendStatus 403


router.post "/update_profile", auth.isAuthenticated(), (req, res, next) ->
  promises = []
  if req.body.email
    promises.push UserUtils.checkEmail req.body.email

  if req.body.nickname
    promises.push UserUtils.checkNickname req.body.nickname

  Q.all promises
  .then ->
    conditions = {userNo: req.user.userNo}
    pickedUpdatedKeys = ['email', 'nickname']
    WrapRequest.wrapUpdate req, res, next, conditions, pickedUpdatedKeys
  .catch next
  .done()


router.get '/me', auth.isAuthenticated(), (req, res, next) ->
  userId = req.user.id
  User.findOne
    _id: userId
    '-salt -hashedPassword'
  .execQ()
  .then (user) -> # donnot ever give out the password or salt
    return res.send 401 if not user?
    res.send user.profile
  , next


router.get "/:userNo", (req, res, next) ->
  findParams =
    conditions: {userNo: req.params.userNo}
    selects: '-salt -hashedPassword'

  WrapRequest.wrapShow req, res, next, findParams


module.exports = router
