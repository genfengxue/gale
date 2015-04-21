express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'
crypto = require 'crypto'

Sentence = _u.getModel 'sentence'
User = _u.getModel 'user'

router.get "/", auth.verifyTokenCookie(), (req, res, next) ->
  token = null
  if req.user
    token = auth.signToken(req.user.userNo)

  res.render 'admin', {token: token}

router.post "/login", (req, res, next) ->
  console.log req.body
  User.findOneQ userNo: req.body.userNo
  .then (user) ->
    if user.authenticate req.body.password
      token = auth.signToken(user.userNo)
      res.cookie('token', token)
      res.redirect("/admin")
    else
      res.send {"msg": 'userNo和password不匹配'}
  .catch next
  .done()

router.post "/add_user", auth.isAdmin(), (req, res, next) ->
  tmpResult = {}
  User.findOneQ {}, null, {sort: {userNo: -1}}
  .then (user) ->
    sha1Hash = crypto.createHash('sha1')
    userNo = user.userNo + 1
    tmpResult.password = (sha1Hash.update(userNo.toString()).digest('hex')).substr 0, 6

    data =
      userNo: userNo
      role: req.body.role
      password: tmpResult.password

    User.createQ data
  .then (doc) ->
    # 用来以后找回初始密码
    loggerD.write JSON.stringify {userNo: doc.userNo, role: doc.role, password: tmpResult.password}

    res.send {userNo: doc.userNo, role: doc.role, password: tmpResult.password, msg: '密码很重要，忘记了要很麻烦才能找回来'}
  .catch next
  .done()


router.get "/sentences", (req, res, next) ->
  conditions = {}
  conditions.lessonNo = req.query.lessonNo if req.query.lessonNo
  Sentence.findQ conditions, null, {sort: {lessonNo: 1, sentenceNo: 1}}
  .then (sentences) ->
    res.render 'sentences', {sentences: sentences}
  .catch next
  .done()

countWords = require '../../local_data/count_words/count_words_converted.json'
numWords = (_.pluck countWords, 'word').length
totalCount = _.reduce(countWords, (sum, ele) ->
  return sum + (if ele.count >= 10 then 10 else ele.count)
, 0)

sortedCountWords = countWords.sort (a, b) ->
  return b.count - a.count

router.get "/count_words", (req, res, next) ->
#  res.send sortedCountWords
  res.render 'count_words', {
    sortedCountWords: sortedCountWords
    numWords: numWords
    totalCount: totalCount
  }

module.exports = router
