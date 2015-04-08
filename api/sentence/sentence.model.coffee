mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Sentence = BaseModel.subclass
  classname: 'Sentence'
  populates:
    index: [
      path: 'keyPoints.kps.kp'
    ]
  initialize: ($super) ->
    @schema = new Schema
      courseNo:
        type: Number
        required: true
      lessonNo:
        type: Number
        required: true
      sentenceNo:
        type: Number
        required: true
      english:
        type: String
        required: true
      chinese:
        type: String
        required: true
      timeline:
        type: String
      keyPoints: [
        key: String
        kps: [
          kp:
            type: Schema.Types.ObjectId
            ref : "key_point"
          isPrimary:
            type: Boolean
            default: false
        ]
      ]

    @schema.index {courseNo: 1, lessonNo: 1, sentenceNo: 1}, {unique: true}

    $super()
