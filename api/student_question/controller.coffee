express = require("express")
router = express.Router()

StudentQuestion = _u.getModel 'student_question'
WrapRequest = new (require '../../utils/WrapRequest')(StudentQuestion)
auth = require '../../auth/auth.service'


router.post "/", auth.isAuthenticated(),  (req, res, next) ->
  pickedKeys = ['keywordString', 'courseNo', 'lessonNo', 'sentenceNo', 'keyPointId']
  data = _.pick req.body, pickedKeys

  if req.body.msgText
    req.body.msgText = 0 if req.body.msgText == undefined
    data.msgList = [
      msgType: req.body.msgType
      msgText: req.body.msgText
      isTeacher: false
    ]

  data.studentNo = req.user.userNo

  WrapRequest.wrapCreate req, res, next, data


router.post "/:id/msg", auth.isAuthenticated(), (req, res, next) ->
  req.body.msgText = 0 if req.body.msgText == undefined
  msg =
    msgType: req.body.msgType
    msgText: req.body.msgText

  if req.user.role == Const.RoleMap['student']
    msg.isTeacher = false
  else
    msg.isTeacher = true
    msg.teacherNo = req.user.userNo

  StudentQuestion.findOneAndUpdateQ req.params.id, {$push: {msgList: msg}}
  .then (doc) ->
    res.send doc
  .catch next
  .done()


#TODO: select certain field
router.get "/", (req, res, next) ->
  conditions = {}
  findParams =
    conditions: conditions
    options: {}

  WrapRequest.wrapIndex req, res, next, findParams


router.get "/:id", (req, res, next) ->
  findParams =
    conditions: {_id: req.params.id}
  WrapRequest.wrapShow req, res, next, findParams


module.exports = router
