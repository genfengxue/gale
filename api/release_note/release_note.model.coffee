mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.ReleaseNote = BaseModel.subclass
  classname: 'ReleaseNote'
  populates: {
  }
  initialize: ($super) ->
    @schema = new Schema
      version:
        type: String
        required: true
        unique: true
      content:
        type: String
        required: true
      releaseDate:
        type: String
        required: true
      created:
        type: Date

    $super()

