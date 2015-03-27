db.sentences.find({lessonNo: 12}).sort({sentenceNo: 1}).forEach(function(sentence) {
  print(sentence._id + " " + sentence.sentenceNo + " " + sentence.lessonNo);
  delete sentence._id;
  sentence.lessonNo = 999;
  db.sentences.save(sentence);
  print(sentence._id);
});
