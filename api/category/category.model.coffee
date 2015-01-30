mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.Category = BaseModel.subclass
  classname: 'Category'
  initialize: ($super) ->
    @schema = new Schema
      categoryNo:
        type: Number
        required: true
        unique: true
      name:
        type: String
        required: true

    $super()
