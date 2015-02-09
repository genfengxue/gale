require '../common/init'

Sentence = _u.getModel 'sentence'

class SentenceUtils
  buildKeyPointsForImportToSentence: (file) ->
    json = require "../local_data/key_point_json/#{file}"
    datas = []
    for lessonNo, sentences of json
      for sentenceNo, keyPoints of sentences
        datas.push {
          lessonNo: lessonNo
          sentenceNo: sentenceNo
          keyPoints: keyPoints
        }

    return datas

exports.SentenceUtils = SentenceUtils
