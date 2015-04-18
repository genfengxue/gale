express = require("express")
router = express.Router()
auth = require '../../auth/auth.service'

KeyPoint = _u.getModel 'key_point'
WrapRequest = new (require '../../utils/WrapRequest')(KeyPoint)

router.get "/", (req, res, next) ->
  conditions = {}
  #关键字搜索
  if req.query.keyword
    regex = new RegExp(_u.escapeRegex(req.query.keyword), 'i')
    conditions.text = regex

  findParams =
    conditions: conditions

  WrapRequest.wrapIndex req, res, next, findParams


pickedKeys = ["question", "text", "audio", "image", "categories", "tags"]
router.post "/", auth.isAdmin(), (req, res, next) ->
  data = _.pick req.body, pickedKeys
  WrapRequest.wrapCreate req, res, next, data

pickedUpdatedKeys = ["question", "text", "audio", "image", "categories", "tags"]
router.put "/:id", auth.isAdmin(), (req, res, next) ->
  conditions = {_id: req.params.id}
  update = _.pick req.body, pickedUpdatedKeys
  WrapRequest.wrapUpdate req, res, next, conditions, update


router.delete "/:id", auth.isAdmin(), (req, res, next) ->
  conditions = {_id: req.params.id}
  WrapRequest.wrapDestroy req, res, next, conditions


module.exports = router
