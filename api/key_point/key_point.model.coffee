mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.KeyPoint = BaseModel.subclass
  classname: 'KeyPoint'
  initialize: ($super) ->
    @schema = new Schema
      question:
        type: String
      text:
        type: String
        required: true
      audio:
        type: String
      image:
        type: String
      categories: [ Number ]
      tags: [ String ]

    $super()
