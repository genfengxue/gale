db.sentences.remove({lessonNo: {$in: [28, 29, 32, 33]}});//2015-02-03 4个lesson的内容有误

db.sentences.update({lessonNo: 12, sentenceNo: 13}, {$set: {english: "He doesn't want cream."}});//2015-02-05 一个字段有误

db.sentences.update({lessonNo: 12}, {$set: {keyPoints: []}}, {multi: true});//2015-02-11 将lesson12的keyPoints字段清空
