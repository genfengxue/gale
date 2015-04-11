express = require("express")
router = express.Router()

router.get "/", (req, res, next) ->
  releaseNotes = [
    version: 'v1.2'
    content: [
      '增加了登录'
      '移除了小米的sd卡'
      '减轻了15g'
      '录音不会挂了'
    ]
    created: '04-11'
  ,
    version: 'v1.1'
    content: [
      '买课程借小米'
      '增加了录音功能'
    ]
    created: '03-20'
  ,
    version: 'v1.0'
    content: [
      'app诞生啦'
    ]
    created: '03-01'
  ]
  res.render 'release_notes', {releaseNotes: releaseNotes}

module.exports = router
