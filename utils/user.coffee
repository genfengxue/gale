require '../common/init'

User = _u.getModel 'user'

class UserUtils
  checkEmail: (userNo, email) ->
    if not Const.isEmail.test email
      return Q.reject(
        status: 200
        errCode: ErrCode.NotValidEmailFormat
        errMsg: 'email格式不合法'
      )

    User.findByEmail email
    .then (user) ->
      if user and ~~user.userNo != ~~userNo
        Q.reject(
          status: 200
          errCode: ErrCode.DuplicateEmail
          errMsg: '当前email已经存在'
        )

  checkNickname: (userNo, nickname) ->
    User.findByNickname nickname
    .then (user) ->
      if user and ~~user.userNo != ~~userNo
        Q.reject(
          status: 200
          errCode: ErrCode.DuplicateNickname
          errMsg: '当前昵称已经存在'
        )

exports.UserUtils = UserUtils
