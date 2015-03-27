//将lesson12的数据复制一份给lesson999
//删除_id，在存储的时候，会自动新建记录

db.sentences.find({lessonNo: 12}).sort({sentenceNo: 1}).forEach(function(sentence) {
  print(sentence._id + " " + sentence.sentenceNo + " " + sentence.lessonNo);
  delete sentence._id;
  sentence.lessonNo = 999;
  db.sentences.save(sentence);
  print(sentence._id);
});
