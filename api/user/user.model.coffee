'use strict'

mongoose = require 'mongoose'
crypto = require 'crypto'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
authTypes = ['google']
BaseModel = (require '../../common/BaseModel').BaseModel
sendActivationMail = require('../../common/mail').sendActivationMail

exports.User = BaseModel.subclass
  classname: 'User'
  initialize: ($super) ->
    @schema = new Schema
      avatar :
        type : String
      email :
        type : String
        lowercase : true
      orgId :
        type : ObjectId
        ref : 'organization'
        required: true
      info :
        type : String
      name :
        type : String
      title:
        type : String
      hashedPassword :
        type : String
      provider :
        type : String
      role :
        type : String
        default : 'student'#TODO change role to Number
      weibo:
        id: String
        name: String
        token: String
      qq:
        id: String
        name: String
        token: String
      weixin:
        id: String
        name: String
        token: String
        other: {}
      salt :
        type : String
      status :
        type : Number # 0: unactivated; 1: activated
        default : 0
      activationCode:
        type: String
      resetPasswordToken :
        type: String
      resetPasswordExpires :
        type: Date

# 这里必须删掉索引，否则微信授权登录的时候，因为相应email字段都为空，会导致索引失败
#    @schema.index {email: 1, orgId: 1}, {unique: true}

    setupUserSchema @schema

    $super()


  findBy: (userInfo) ->
    conditions = {$or: []}
    conditions.orgId = userInfo.orgId if userInfo.orgId
    conditions.$or.push(email: userInfo.email) if userInfo.email?

    if _.isEmpty conditions.$or
      return Q.reject
        status: 400
        errCode: ErrCode.IllegalFields
        errMsg: 'email字段不能为空'

    @findOneQ conditions

  getIdAndRold: (conditions) ->
    @findQ conditions, "_id role"

  getStudentById: (studentId) ->
    return @findOneQ _id: studentId, role: 'student'
    .then (student) ->
      unless student
        return Q.reject
          status: 404
          errCode: ErrCode.InvalidStudent
          errMsg: '不存在相应学生'

      return student

###
Virtuals
###
setupUserSchema = (UserSchema) ->
  # login passord
  UserSchema
  .virtual 'password'
  .set (password) ->
    this._password = password
    this.salt = this.makeSalt()
    this.hashedPassword = this.encryptPassword(password)
  .get () ->
    this._password

  # Public profile information
  UserSchema
  .virtual 'profile'
  .get () ->
    '_id': this._id
    'name': this.name
    'role': this.role
    'info': this.info
    'email': this.email
    'weixin': {id:this.weixin?.id, name:this.weixin?.name}
    'avatar': this.avatar
    'status': this.status

  # Non-sensitive info we will be putting in the token
  UserSchema
  .virtual 'token'
  .get () ->
    '_id': this._id
    'role': this.role

  # Validate empty email
  UserSchema
  .path 'email'
  .validate (email) ->
    return @weixin.id or email.length
  , '邮箱地址不能为空'

  # Validate empty password
  UserSchema
  .path 'hashedPassword'
  .validate (hashedPassword) ->
    return @weixin.id or hashedPassword.length
  , '登录密码不能为空'

  # Validate email is not taken
  UserSchema
  .path 'email'
  .validate (value, respond) ->
    self = this
    this.constructor.findOne
      email: value
      orgId: self.orgId
    , (err, user) ->
      throw err if err
      notTaken = !user or user.id == self.id
      respond notTaken
  , '该邮箱地址已经被占用，请选择其他邮箱'

  validatePresenceOf = (value) ->
    value && value.length

  UserSchema
  .pre 'save', (next) ->
    if this.isNew
      UserUtils = _u.getUtils 'user'
      this.activationCode = UserUtils.generateActivationCode this.email

    next()

# 密码的相关验证器已经存在，这里不需要重复验证
#    if not validatePresenceOf(this.hashedPassword) and authTypes.indexOf(this.provider) is -1
#      next new Error '用户名或者密码错误'
#    else
#      next()

  UserSchema.methods =
    ###
      Authenticate - check if the passwords are the same
      @param {String} plainText
      @return {Boolean}
      @api public
    ###
    authenticate: (plainText) ->
      this.encryptPassword(plainText) is this.hashedPassword

    ###
     Make salt
     @return {String}
     @api public
    ###
    makeSalt: () ->
      crypto.randomBytes 16
      .toString 'base64'

    ###
      Encrypt password

      @param {String} password
      @return {String}
      @api public
    ###
    encryptPassword: (password) ->
      '' if  not password or not this.salt
      salt = new Buffer this.salt, 'base64'
      crypto.pbkdf2Sync password, salt, 10000, 64
      .toString 'base64'
