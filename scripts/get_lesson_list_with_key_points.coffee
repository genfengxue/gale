require '../common/init'

Sentence = _u.getModel 'sentence'

result = {}
for courseName, courseInfo of Const.Course
  result[courseInfo.CourseNo] = []

console.log result

Sentence.findQ {}
.then (docs) ->
  _.each docs, (doc) ->
    if doc.keyPoints.length > 0
      result[doc.courseNo].push doc.lessonNo

  for courseNo, stat of result
    result[courseNo] = (_.uniq stat).sort()
    console.log "课程#{courseNo}已经导入#{result[courseNo].length}课的知识点，列表如下："
    console.log result[courseNo]

  return result
, (err) ->
  console.log err
