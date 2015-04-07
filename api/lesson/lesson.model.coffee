mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Lesson = BaseModel.subclass
  classname: 'Lesson'
  populates: {
  }
  initialize: ($super) ->
    @schema = new Schema
      courseNo:
        type: Number
        required: true
      lessonNo:
        type: Number
        required: true
      englishTitle:
        type: String
        required: true
      chineseTitle:
        type: String
        required: true
      imageUrl:
        type: String
      videoUrl:
        type: String

    @schema.index {courseNo: 1, lessonNo: 1}, {unique: true}

    $super()
