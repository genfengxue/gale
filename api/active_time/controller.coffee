express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'
moment = require 'moment'

ActiveTime = _u.getModel 'active_time'
WrapRequest = new (require '../../utils/WrapRequest')(ActiveTime)

router.get "/", (req, res, next) ->
  WrapRequest.wrapIndex req, res, next

pickedKeys = ['']
router.post "/", auth.isAuthenticated(), (req, res, next) ->
  date = moment(req.body.date)
  date.hours(0)
  date.minutes(0)
  date.seconds(0)

  console.log req.body
  update = _.pick req.body, ['pronunciation', 'vocabulary', 'class', 'input']
  ActiveTime.updateQ {studentNo: req.user.studentNo, date: date}, update, {upsert: true}
  .then (result) ->
    res.send result
  .catch next
  .done()


module.exports = router

# curl -d 'date=2015-03-26T00:00:00.000Z&input=555' 'http://localhost:9000/api/active_times?access_token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50Tm8iOjIwMTUwMDAxLCJpYXQiOjE0Mjc0NjcwNDEsImV4cCI6MTQyODA3MTg0MX0.JDmgWeco54p2BgHP1_MCmFqfsPqCEMSvNUbWdObtd38'
