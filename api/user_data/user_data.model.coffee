mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.UserData = BaseModel.subclass
  classname: 'UserData'
  populates: {
  }
  initialize: ($super) ->
    @schema = new Schema
      userNo:
        type: Number
        required: true
      dataTag:
        type: String
        required: true
      content:
        type: String
        required: true

    $super()
