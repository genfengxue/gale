mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.KeyPoint = BaseModel.subclass
  classname: 'KeyPoint'
  initialize: ($super) ->
    @schema = new Schema
      title:
        type: String
        required: true
      text:
        type: String
        required: true
      categories: [ ]
      tags: [ String ]

    $super()
