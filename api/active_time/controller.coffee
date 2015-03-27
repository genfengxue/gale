express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

Active_time = _u.getModel 'active_time'
WrapRequest = new (require '../../utils/WrapRequest')(Active_time)

router.get "/", (req, res, next) ->
  WrapRequest.wrapIndex req, res, next

router.post "/", auth.isAuthenticated(), (req, res, next) ->
  console.log req.body
  res.send result: 'ok'

module.exports = router

# curl -d "oldPassword=e45620&newPassword=e45620" 'http://localhost:9000/api/active_times?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50Tm8iOjIwMTUwMDAxLCJpYXQiOjE0Mjc0NjcwNDEsImV4cCI6MTQyODA3MTg0MX0.JDmgWeco54p2BgHP1_MCmFqfsPqCEMSvNUbWdObtd38'
