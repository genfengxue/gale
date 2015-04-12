require '../common/init'
User = _u.getModel 'user'

User.createQ {
  role    : 20
  name    : 'Admin'
  email   : 'admin@admin.com'
  password: 'admin'
  userNo  : 0
}, {
  role    : 2
  name    : 'teacher1'
  email   : 't1@11.com'
  password: 'teacher'
  userNo  : 1
}, {
  role    : 1
  name    : 'student1'
  email   : 's1@s1.com'
  password: 'student'
  userNo  : 2
}
.then ->
  console.log 'finished populating user'
