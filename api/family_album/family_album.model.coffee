mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.FamilyAlbum = BaseModel.subclass
  classname: 'FamilyAlbum'
  populates:
    index: [
    ]
  initialize: ($super) ->
    @schema = new Schema
      lessonNo:
        type: String
        required: true
      sentenceNo:
        type: Number
        required: true
      english:
        type: String
        required: true

    @schema.index {english: 'text'}

    $super()
