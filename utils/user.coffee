require '../common/init'

User = _u.getModel 'user'

class UserUtils
  checkEmail: (email) ->
    if not Const.isEmail.test email
      return Q.reject(
        status: 400
        errCode: ErrCode.NotValidEmailFormat
        errMsg: 'email格式不合法'
      )

    User.findByEmail email
    .then (user) ->
      if user
        Q.reject(
          status: 400
          errCode: ErrCode.DuplicateEmail
          errMsg: '当前email已经存在'
        )

  checkNickname: (nickname) ->
    User.findByNickname nickname
    .then (user) ->
      if user
        Q.reject(
          status: 400
          errCode: ErrCode.DuplicateNickname
          errMsg: '当前昵称已经存在'
        )

exports.UserUtils = UserUtils
