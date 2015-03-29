'use strict'

mongoose = require 'mongoose'
crypto = require 'crypto'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId
BaseModel = (require '../../common/BaseModel').BaseModel

exports.User = BaseModel.subclass
  classname: 'User'
  initialize: ($super) ->
    @schema = new Schema
      userNo:
        type: Number
        required: true
        unique: true
      role:
        type: Number
        required: true
      nickname:
        type: String
        unique: true
        sparse: true
      avatar:
        type: String
      email:
        type: String
        lowercase: true
      hashedPassword :
        type : String
      salt :
        type : String

    setupUserSchema @schema

    $super()

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
    userNo: this.userNo
    role: this.role
    nickname: this.nickname
    avatar: this.avatar
    email: this.email

  # Non-sensitive info we will be putting in the token
  UserSchema
  .virtual 'token'
  .get () ->
    userNo: this.userNo
    role: this.role

  # Validate empty password
  UserSchema
  .path 'hashedPassword'
  .validate (hashedPassword) ->
    return hashedPassword.length
  , '登录密码不能为空'

  validatePresenceOf = (value) ->
    value && value.length

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
      '' if not password or not this.salt
      salt = new Buffer this.salt, 'base64'
      crypto.pbkdf2Sync password, salt, 10000, 64
      .toString 'base64'
