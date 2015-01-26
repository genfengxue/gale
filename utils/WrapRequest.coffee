require '../common/init'

class WrapRequest
  constructor: (@Model) ->

  populateQuery: (mongoQuery, options = []) ->
    for option in options
      mongoQuery = mongoQuery.populate option

    return mongoQuery

  populateDoc: (mongoDoc, options = []) ->
    for option in options
      mongoDoc = mongoDoc.populate option

    mongoDoc.populateQ()


  wrapPageIndex: (req, res, next, conditions) ->
    conditions.deleteFlag = {$ne: true}
    logger.info 'page index conditions:', conditions

    #旧版的options构造都是在controller中完成，现移至此处
    #在功能上，和旧版代码兼容，但旧版代码会残留一些与此有关的无用代码
    #若遇到了，可酌情删除
    options =
      limit: req.query.limit
      from : req.query.from
      sort : req.query.sort
    logger.info 'page index options:', options

    # 若有sort参数传递，则解析结果，否则直接使用默认排序{created: -1}
    if options.sort?
      try
        options.sort = JSON.parse(options.sort)
      catch err
        logger.error err
        options.sort = null

    #从limit中取值，若未定义，则去PageSize中制定model的值，否则，取Default的值
    pageSize = options.limit ?
               Const.PageSize[@constructor.name] ?
               Const.PageSize.Default
    mongoQuery = @Model.find conditions
      .sort options.sort ? {created: -1}
      .limit _.min [~~pageSize, Const.MaxPageSize]
      .skip _.max [~~options.from, Const.MinSkipNum]

    mongoQuery = @populateQuery mongoQuery, @Model.populates?.index

    Q.all [
      mongoQuery.execQ()
      @Model.countQ conditions
    ]
    .then (data) ->
      res.send
        results: data[0]
        count: data[1]
    .catch next
    .done()


  wrapIndex: (req, res, next, conditions) ->
    conditions.deleteFlag = {$ne: true}
    logger.info 'index conditions:', conditions

    mongoQuery = @Model.find conditions
    mongoQuery = @populateQuery mongoQuery, @Model.populates?.index

    mongoQuery.execQ()
    .then (docs) ->
      res.send docs
    .catch next
    .done()


  wrapShow: (req, res, next, conditions, update) ->
    logger.info 'show conditions:', conditions
    mongoQuery = (
      if _.isEmpty update
        @Model.findOne conditions
      else
        @Model.findOneAndUpdate conditions, update
    )
    mongoQuery = @populateQuery mongoQuery, @Model.populates?.show

    mongoQuery.execQ()
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapCreate: (req, res, next, data) ->
    logger.info 'create data:', data
    @Model.createQ data
    .then (newDoc) =>
      @populateDoc newDoc, @Model.populates?.create
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapCreateAndUpdate: (req, res, next, data, updateModel, updateConds, update) ->
    logger.info "wrapCreateAndUpdate =>
                create data:", data,
                "||| updateModel: #{updateModel?.constructor.name}
                ||| updateConds:", updateConds,
                "||| update:", update
    tmpResult = {}
    @Model.createQ data
    .then (newDoc) =>
      tmpResult.newDoc = newDoc
      if updateModel
        updateModel.updateQ updateConds, update
    .then () =>
      @populateDoc tmpResult.newDoc, @Model.populates?.create
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapUpdate: (req, res, next, conditions, pickedUpdatedKeys) ->
    data = {}
    if pickedUpdatedKeys.omit
      data = _.omit req.body, pickedUpdatedKeys.omit
    else
      data = _.pick req.body, pickedUpdatedKeys

    @Model.findOneQ conditions
    .then (doc) ->
      updated = _.extend doc, data
      do updated.saveQ
    .then (result) =>
      @populateDoc result[0], @Model.populates?.update
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapChangeStatus: (req, res, next, conditions, update) ->
    logger.info 'change status conditions:', conditions
    logger.info 'change status update:', update
    @Model.findOneAndUpdateQ conditions, update
    .then (doc) ->
      res.send doc
    .catch next
    .done()


  wrapDestroy: (req, res, next, conditions) ->
    logger.info 'destroy conditions:', conditions

    (if @Model.schema.paths.deleteFlag
      @Model.updateQ conditions, {deleteFlag: true}
    else
      @Model.removeQ conditions
    ).then () ->
      res.send 204
    .catch next
    .done()


module.exports = WrapRequest
