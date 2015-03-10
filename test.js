isExistFunc = function(cb) {
  dynamodb.getItem(params, function(err, data) {
    if (err) {
      console.log(err); // an error occurred
      return cb(err);
    } else {
      console.log(data); // successful response
      if (data) {
        console.log("exist");
        exist = true;
        return cb(null, true);
      } else {
        return cb(null, false);
      }
    }
  });
};
//这里的cb是外面传进来的一个回调function，函数的使用方法如下：
isExistFunc(function(err, isExist) {
  if (err) {
    return console.log(err); // an error occurred
  }

  console.log(isExist);
});
//一旦在执行过程中遇到异步操作，那就不能用return直接获取返回结果，而应该用回调函数cb来传出结果
//cb的约定一般第一个参数err，第二个参数是执行结果，就想我上面举的例子一样，所以每次都要单独判断err是否为真
//了解了这个概念之后，就可以用更简单的方式来写isExistFunc了
isExistFunc = function(cb) {
  dynamodb.getItem(params, function(err, data) {
    cb(err, !!data);//整个处理逻辑一行就搞定了，你可以看看能不能理解是什么意思，写这种弱类型语言，可以稍微随意一点，不用像强类型一样
  });
};
