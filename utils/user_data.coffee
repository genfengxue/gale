require '../common/init'

class UserDataUtils
  buildDatas: (records, userNo) ->
    unless records.length
      return Q.reject(
        status: 400
        errCode: ErrCode.ReqBodyIsEmpty
        errMsg: "记录条数有错误: #{records.length}"
      )

    for record in records
      unless record.dataTag and record.content
        return Q.reject(
          status: 400
          errCode: ErrCode.EmptyField
          errMsg: "dataTag: #{record.dataTag}; content: #{record.content}; 两个字段都不能为空"
        )

      delete record._id
      record.userNo = userNo
      record

    Q(records)

exports.UserDataUtils = UserDataUtils
