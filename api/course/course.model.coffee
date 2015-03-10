mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Course = BaseModel.subclass
  classname: 'Course'
  populates: {
  }
  initialize: ($super) ->
    @schema = new Schema
      courseNo:
        type: Number
        required: true
        unique: true
      englishTitle:
        type: String
        required: true
      chineseTitle:
        type: String
        required: true
      description:
        type: String
      imageUrl:
        type: String

    $super()
