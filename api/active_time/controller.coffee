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
  ActiveTime.updateQ {userNo: req.user.userNo, date: date}, update, {upsert: true}
  .then (result) ->
    res.send result
  .catch next
  .done()


module.exports = router
