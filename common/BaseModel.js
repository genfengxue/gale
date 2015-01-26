require('./init');
var Class = require('./Class').Class;
var mongoose;
var models = {};
//var createdModifiedPlugin = require('mongoose-createdmodified').createdModifiedPlugin;

var methods = [
    // mongoose.Model static
    'remove', 'ensureIndexes', 'find', 'findById', 'findOne', 'count', 'distinct',
    'findOneAndUpdate', 'findByIdAndUpdate', 'findOneAndRemove', 'findByIdAndRemove',
    'create', 'update', 'mapReduce', 'aggregate', 'populate',
    'geoNear', 'geoSearch',
    // mongoose.Document static
    'update'
];

var body = {
    classname : 'BaseModel',
    model: null,
    mongoose: null,
    schema: null,
    schemaParams: {},
    dbURL : '',

    initialize : function() {
        if(_.isEmpty(mongoose)){
//            mongoose = require('mongoose');
            mongoose = require('mongoose-q')(null, {spread: true});
            var dbURL = this.dbURL || config.mongo.uri;
            var connection = mongoose.connect(dbURL, config.mongo.options).connection;

            connection.on('error', function(err) {
                console.log('connection error:' + err);
            });

            connection.once('open', function() {
                console.log('open mongodb success');
            });
        }

        this.mongoose = mongoose;

        if (this.schema) {
            this.createModel(_u.convertToSnakeCase(this.classname));
        }
    },

    createModel : function(name){
//        if (name !== 'invert_index') {
//          this.schema.plugin(createdModifiedPlugin, {index: true});
//        }
        if(!models[name]) {
            models[name] = mongoose.model(name, this.schema);
        }

        this.model = models[name];
        return this.model;
    },

    newModel : function(data){
        if(!this.model) return null;

        return new this.model(data);
    },

    save : function(data, cb) {
        var newData = this.newModel(data);
        newData.save(function(err, res) {
            cb(err, res);
        });
    },

    getSaveFunc : function(data) {
        return this.save.bind(this, data);
    },

    validate: function(data, cb) {
        var newData = this.newModel(data);
        newData.validate(cb);
    },

    findAll : function(cb) {
        return this.model.find.apply(this.model, [{}].concat(_.toArray(arguments)));
    },

    findAllQ : function(cb) {
        return this.model.findQ.apply(this.model, [{}].concat(_.toArray(arguments)));
    },

    /*
     * @description Return result as hash
     * // return { 2 : { id: 1, id2: 2 } }
     * Model.findIndexBy("id2", conditions, function(err, map) {...});
     */
    findIndexBy : function() {
        var index = Array.prototype.shift.apply(arguments);
        var callback = arguments[arguments.length - 1];
        arguments[arguments.length - 1] = function(err, list) {
            callback(err, _.indexBy(list, index));
        };
        this.find.apply(this, arguments);
    },

};

_.each(methods, function(method) {
  body[method] = function() {
    return this.model[method].apply(this.model, arguments);
  };

  var methodQ = method + 'Q';
  body[methodQ] = function() {
    return this.model[methodQ].apply(this.model, arguments);
  };
});

exports.BaseModel = Class.subclass(body);
