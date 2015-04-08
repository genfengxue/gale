module.exports =
  RoleMap:
    'student': 1
    'teacher': 2
    'admin': 20
  KeyPointJsonPathPattern: '%s_key_point_json'
  SentenceJsonPathPattern: '%s_json'
  Course:
    nceone:
      KeyPointFilePattern: 'nceone%03s.txt.json'
      SentenceFilePattern: 'nceone%03s.srt.json'
      CourseNo: 1
    de:
      KeyPointPath: 'de%03s.txt.json'
      KeyPointFilePattern: 'de%03s.txt.json'
      SentenceFilePattern: 'de%03s.srt.json'
      CourseNo: 2
