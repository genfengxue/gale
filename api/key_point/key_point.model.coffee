mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.KeyPoint = BaseModel.subclass
  classname: 'KeyPoint'
  initialize: ($super) ->
    @schema = new Schema
      text:
        type: String
        required: true
      question:
        type: String
      audio:
        type: String
      image:
        type: String
      categories: [ Number ]
      tags: [ String ]
      isPrimary:
        type: Boolean
        default: false

    $super()
