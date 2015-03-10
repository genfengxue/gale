express = require("express")
router = express.Router()

Sentence = _u.getModel 'sentence'

router.get "/", (req, res, next) ->
  conditions = {}
  conditions.lessonNo = req.query.lessonNo if req.query.lessonNo
  Sentence.findQ conditions, null, {sort: {lessonNo: 1, sentenceNo: 1}}
  .then (sentences) ->
    res.render 'index', {sentences: sentences}
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
