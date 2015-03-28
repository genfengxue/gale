express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

User = _u.getModel 'user'
WrapRequest = new (require '../../utils/WrapRequest')(User)

router.post "/changePassword", auth.isAuthenticated(), (req, res, next) ->
  studentNo = req.user.studentNo
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

router.get "/:studentNo", (req, res, next) ->
  findParams =
    conditions: {studentNo: req.params.studentNo}
    selects: '-salt -hashedPassword'

  WrapRequest.wrapShow req, res, next, findParams


module.exports = router

# curl -d "password=xxxxx" http://localhost:9000/api/users/changePassword
# curl -d "oldPassword=e45620&newPassword=e45620" http://localhost:9000/api/users/changePassword?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50Tm8iOjIwMTUwMDAxLCJpYXQiOjE0MjY1MTU2NzcsImV4cCI6MTQyNzEyMDQ3N30.6OdZwtxcbwaPn1XbsRFK7WLEn62JX-GbI0geZ56D4IM
