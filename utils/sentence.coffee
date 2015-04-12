require '../common/init'

Sentence = _u.getModel 'sentence'
KeyPoint = _u.getModel 'key_point'

class SentenceUtils
  importKeyPoints: (courseName, file) ->
    courseNo = Const.Course[courseName].CourseNo
    json = require "../local_data/#{courseName}_key_point_json/#{file}"
    promises = []
    for lessonNo, sentences of json
      lessonNo = ~~lessonNo
      for sentenceNo, keyPointMap of sentences
        promises.push @importOneSentence courseNo, lessonNo, sentenceNo, keyPointMap

    Q.all promises
    .then ->
      logger.warn "load success: #{file}"

  importOneSentence: (courseNo, lessonNo, sentenceNo, keyPointMap) ->
    promises = for key, texts of keyPointMap
      @importOneKey key, texts

    if courseNo is Const.Course.nceone.CourseNo
      lessonNo += 300

    Q.all promises
    .then (keyPoints) ->
      Sentence.updateQ {courseNo: courseNo, lessonNo: lessonNo, sentenceNo: sentenceNo}, {$set: {keyPoints: keyPoints}}
    .then ->
      logger.info "success: #{courseNo}-#{lessonNo}-#{sentenceNo}"

  importOneKey: (key, texts) ->
    keyPoint = {key: key, kps: []}
    promises = for text in texts
      KeyPoint.createQ text: text
      .then (doc) ->
        keyPoint.kps.push(
          kp: doc._id
        )

    Q.all promises
    .then ->
      keyPoint.kps[0].isPrimary = true #一个key上挂多个知识点时，第一个为primary
      return keyPoint

  loadSentences: (courseName, file) ->
    datas = require "../local_data/#{courseName}_json/#{file}"
    Sentence.createQ datas
    .then (results) ->
      logger.info "success: #{file}"
    , (err) ->
      logger.info "fail: #{file}"
      logger.info err
      process.exit 1

exports.SentenceUtils = SentenceUtils
