require '../common/init'

Course = _u.getModel 'course'
datas = require '../local_data/others/course_list.json'
Course.createQ datas
.then (docs) ->
  courseNos = _.pluck docs, 'courseNo'
  logger.info courseNos
  logger.info "load success"
, (err) ->
  logger.info err
  process.exit 1

# coffee scripts/load_course_list_json_to_db.coffee
