mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Sentence = BaseModel.subclass
  classname: 'Sentence'
  initialize: ($super) ->
    @schema = new Schema
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
          kpId:
            type: Schema.Types.ObjectId
            ref : "key_point"
          isPrimary:
            type: Boolean
            default: false
        ]
      ]

    $super()
