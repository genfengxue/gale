require '../common/init'

FamilyAlbum = _u.getModel 'family_album'

datas = require '../local_data/others/family_album_all.json'
console.log datas

FamilyAlbum.createQ datas
.then (results) ->
  logger.info results.length
  logger.info "success"
, (err) ->
  logger.info "fail"
  logger.info err
  process.exit 1
