require '../common/init'
User = _u.getModel 'user'
User.findOneQ {userNo: 3}
.then (doc) ->
  doc.password = process.env.P ? process.exit 1
  console.log doc
  do doc.saveQ
.then (result) ->
  console.log result
, (err) ->
  console.log err
