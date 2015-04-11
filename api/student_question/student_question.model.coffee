mongoose = require("mongoose")
Schema = mongoose.Schema
ObjectId = Schema.Types.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.StudentQuestion = BaseModel.subclass
  classname: 'StudentQuestion'
  populates: {
  }
  initialize: ($super) ->
    @schema = new Schema
      keywordString:
        type: String
      keyPointId:
        type: ObjectId
        ref : "key_point"
      studentNo:
        type: Number
        required: true
      courseNo:
        type: Number
        required: true
      lessonNo:
        type: Number
        required: true
      sentenceNo:
        type: Number
        required: true
      msgList: [ #对答列表，数组格式，里面每条消息的数据结构如下
        msgType: Number #消息类型，如果将来支持语音的话，会有一个type表示语音，然后需要根据msgText的url地址去拿到相应的文件, 0: text
        msgText: String #消息内容，可能就是字符串，也可能是文本
        createdAt:
          type: Date #这条消息的创建时间
          default: Date.now
        isTeacher: Boolean #创建者是否是老师，值为true或false，用来区分显示在左边还是右边
        teacherNo: Number
      ]
      updatedAt:
        type: Date
      isRead:
        type: Boolean

    $super()
