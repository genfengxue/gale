express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'
crypto = require 'crypto'

Sentence = _u.getModel 'sentence'
User = _u.getModel 'user'
FamilyAlbum = _u.getModel 'family_album'

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
    userNo = user.userNo + 1
    tmpResult.password = random.nextInt(100000, 1000000).toString()

    tmpResult.data =
      userNo: userNo
      role: req.body.role
      nickname: req.body.nickname
      password: tmpResult.password

    User.createQ tmpResult.data
  .then (doc) ->
    # 记个日志用来以后找回初始密码
    loggerD.write {type: 'add_user', data: tmpResult.data}

    res.send """
    昵称：#{doc.nickname}<br>
    账号: #{doc.userNo}<br>
    密码：#{tmpResult.password}<br>
    """
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

buildCountWordsObject = (filename) ->
  countWords = require "../../local_data/count_words/#{filename}"
  numWords = (_.pluck countWords, 'word').length
  totalCount = _.reduce(countWords, (sum, ele) ->
    return sum + (if ele.count >= 10 then 10 else ele.count)
  , 0)

  sortedCountWords = countWords.sort (a, b) ->
    return b.count - a.count

  return {
    sortedCountWords: sortedCountWords
    numWords: numWords
    totalCount: totalCount
  }

countWordsObject = buildCountWordsObject('count_words_converted.json')

router.get "/count_words", (req, res, next) ->
#  res.send sortedCountWords
  res.render 'count_words', countWordsObject


familyAlbumCountWordsObject = buildCountWordsObject('family_album_converted_count_words.json')

router.get "/family_album_count_words", (req, res, next) ->
  res.render 'count_words', familyAlbumCountWordsObject

router.get "/search", (req, res, next) ->
  res.render 'search_results', {results: [], keyword: '', textKeyword: ''}

router.post "/search", (req, res, next) ->
  keyword = req.body.keyword
  textKeyword = req.body.textKeyword
  console.log(req.body)
  Q(
    if keyword
      console.log(keyword)
      pattern = new RegExp("\\b#{keyword}\\b")
      FamilyAlbum.findQ {english: {$regex: pattern}}
    else if textKeyword
      console.log(textKeyword)
      FamilyAlbum.findQ {
        $text: {$search: textKeyword}
      }, {score: {$meta: 'textScore'}}, {sort: {score: {$meta: 'textScore'}}}
  )
  .then (results) ->
    console.log(results)
    res.render 'search_results', {results: results, keyword: keyword ? '', textKeyword: textKeyword ? ''}
  .catch next
  .done()

module.exports = router
