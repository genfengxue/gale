require '../common/init'

Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'

class SentenceUtils
  importKeyPoints: (file) ->
    json = require "../local_data/key_point_json/#{file}"
    promises = []
    for lessonNo, sentences of json
      for sentenceNo, keyPointMap of sentences
        promises.push @importOneSentence lessonNo, sentenceNo, keyPointMap

    Q.all promises
    .then () ->
      logger.warn "load success: #{file}"

  importOneSentence: (lessonNo, sentenceNo, keyPointMap) ->
    promises = for key, texts of keyPointMap
      @importOneKey key, texts

    Q.all promises
    .then (keyPoints) ->
      Sentence.updateQ {lessonNo: lessonNo, sentenceNo: sentenceNo}, {$set: {keyPoints: keyPoints}}
    .then () ->
      logger.info "success: lessonNo: #{lessonNo}, sentenceNo: #{sentenceNo}"

  importOneKey: (key, texts) ->
    keyPoint = {key: key, kps: []}
    promises = for text in texts
      KeyPoint.createQ text: text
      .then (doc) ->
        keyPoint.kps.push(
          kp: doc._id
        )

    Q.all promises
    .then () ->
      keyPoint.kps[0].isPrimary = true #一个key上挂多个知识点时，第一个为primary
      return keyPoint

exports.SentenceUtils = SentenceUtils
