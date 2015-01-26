/**
 * The default constructor.
 * @constructor 
 * @class The <code>Class</code> object provides an environment for Object Oriented Programming (OOP) development in Javascript, such as Java or C++.
 * @name Core.Class
 */
var Class = function() {}
exports.Class = Class;

/**
 * Create a new class by extending another class.
 * @example
 * var MyClass = Class.subclass(
 * {
 *    initialize: function()
 *    {
 *        console.log('constructor');
 *    },
 *    foo: function(v)
 *    {
 *        console.log('MyClass.foo(' + v + ')');
 *    },
 * });
 * var myClass = new MyClass();
 * myClass.foo('param');
 * @param {Object} extensions Object literal containing new functions for the derived class.
 * @function
 * @name Core.Class.subclass
 * @status iOS, Android, Flash, Test, iOSTested, AndroidTested
 */
Class.subclass = (function()
{
/**#@+ @ignore */
	// Parse a function body and extract the parameter names.
	function argumentNames(body)
	{
		var names = body.toString().match(/^[\s\(]*function[^(]*\(([^)]*)\)/)[1]
			.replace(/\/\/.*?[\r\n]|\/\*(?:.|[\r\n])*?\*\//g, '')
			.replace(/\s+/g, '').split(',');
		return names.length == 1 && !names[0] ? [] : names;
	}
	
	// Create a function that calls overrideBody with a closure to ancestorBody.
	function overrideMethod(overrideBody, ancestorBody)
	{
		if(ancestorBody !== undefined)
		{
			// Create a function that calls overrideBody with a closure to ancestorBody as the first param.
			var override = function()
			{
				var localThis = this;
				var $super = function() { return ancestorBody.apply(localThis, arguments) };
				Array.prototype.unshift.call(arguments, $super);
				return overrideBody.apply(this, arguments);
			}
		}
		else
		{
			// Create a function that calls overrideBody with undefined as the first param, because ancestorBody is undefined.
			var override = function()
			{
				Array.prototype.unshift.call(arguments, undefined);
				return overrideBody.apply(this, arguments);
			}
		}

		// Hide our dirty tricks from the rest of the world.
		override.valueOf = function() { return overrideBody.valueOf() };
		override.toString = function() { return overrideBody.toString() };
		return override;
	}
	
	// Define some empty functions used later. This is a speed optimization.
	function TempClass() {}
	function emptyFunction() {}
	
	return function()
	{
		// Constructor for new class to be created.
		var properties = arguments[0];
		var classname = properties.classname || "AnonymousClass";
		var NewClass = eval('(function ' + classname + '(){this.initialize.apply(this, arguments)})');
		
		// Copy statics from this.
		for(var property in this)
		{
			if(!this.hasOwnProperty(property)) continue;
			NewClass[property] = this[property];
		}
		
		// Copy prototype from this.
		var ancestorPrototype = this.prototype;
		TempClass.prototype = ancestorPrototype;
		NewClass.prototype = new TempClass();
		NewClass.prototype.superclass = ancestorPrototype;
		NewClass.prototype.constructor = NewClass;
		
		// Copy properties into NewClass prototype.
		for(var property in properties)
		{
			if(!properties.hasOwnProperty(property)) continue;

			// getters / setters behave differently than normal properties.
			var getter = properties.__lookupGetter__(property)
			var setter = properties.__lookupSetter__(property)
			if(getter || setter)
			{
				if(getter)
				{
					// Copy getter into klass.
					var value = getter;
					if(argumentNames(value)[0] == "$super")
						value = overrideMethod(value, ancestorPrototype.__lookupGetter__(property));
					NewClass.prototype.__defineGetter__(property, value);
				}

				if(setter)
				{
					// Copy setter into klass.
					var value = setter;
					if(argumentNames(value)[0] == "$super")
						value = overrideMethod(value, ancestorPrototype.__lookupSetter__(property));
					NewClass.prototype.__defineSetter__(property, value);
				}
			}
			else
			{
				var value = properties[property];
				if(typeof value === "function" && property[0] != '$')
				{
					if(argumentNames(value)[0] == "$super")
					{
						// Create override method if first param is $super.
						value = overrideMethod(value, ancestorPrototype[property]);
					}
					else if(property == 'initialize')
					{
						var ancestorInitialize = ancestorPrototype.initialize
						if(ancestorInitialize)
						{
							// Automatically call inherited constructor.
							var derivedInitialize = value;
							value = function()
							{
								ancestorInitialize.apply(this, arguments);
								derivedInitialize.apply(this, arguments);
							};
						}
					}
					else if(property == 'destroy')
					{
						var ancestorDestroy = ancestorPrototype.destroy
						if(ancestorDestroy)
						{
							// Automatically call inherited destructor.
							var derivedDestroy = value;
							value = function()
							{
								derivedDestroy.apply(this, arguments);
								ancestorDestroy.apply(this, arguments);
							};
						}
					}

					// Copy function into new class prototype.
					NewClass.prototype[property] = value;
				}
				else
				{
					if(property[0] == '$')
						property = property.slice(1);

					// Copy enum into new class and the prototype.
					NewClass[property] = value;
					NewClass.prototype[property] = value;
				}
			}
		}
		
		// Make sure the is an initialize function.
		if(!NewClass.prototype.initialize)
			NewClass.prototype.initialize = emptyFunction;

		return NewClass;
	}
/**#@-*/
})();

/**
 * Create a singleton by extending a class.
 * @example
 * var MySingleton = Class.singleton(
 * {
 *    initialize: function()
 *    {
 *        console.log('constructor');
 *    },
 *    foo: function(v)
 *    {
 *        console.log('MyClass.foo(' + v + ')');
 *    },
 * });
 * MySingleton.foo('param');
 * @param {Object} extensions Object literal containing new functions for the singleton.
 * @function
 * @name Core.Class.singleton
 * @status iOS, Android, Flash, Test, iOSTested, AndroidTested
 */
Class.singleton = function()
{
	// Create sublcass as normal.
	var tempClass = this.subclass.apply(this, arguments);
	
	// Hide the initialize.
	var initialize = tempClass.prototype.initialize;
	tempClass.prototype.initialize = function() {};
	
	// Now instantiate.
	var instance = new tempClass();
	
	// Hide every prototype function with an instance function that calls initialize.
	var functions = [];
	/** 
	 * Ensure that the singleton has been created and fully initialized.
	 * @status iOS, Android, Flash
	*/
	var instantiate = function(real)
	{
		// Delete all of the instance functions we added.
		for(var i in functions)
		{
			var func = functions[i];
			delete instance[func];
		}
		
		// Restore the initialize function and call it.
		instance.initialize = initialize;
		instance.initialize();
		
		// Replace instantiate method with an empty function.
		instance.instantiate = function() {};
		
		// Call the function that caused this instantiation.
		var args = Array.prototype.slice.call(arguments, 1);
		return real.apply(instance, args);
	}
	
	// Iterate over all prototype functions.
	for(var i in instance)
	{
		// Don't do anything for setters or getters.
		if(instance.__lookupGetter__(i)
			|| instance.__lookupSetter__(i))
		{
			//TODO Should put proxies here too.
			continue;
		}
			
		var value = instance[i];
		if(typeof(value) == 'function')
		{
			// Remember the function names that we added so that instantiate() can remove them.
			functions.push(i);
			
			// Add an instance function to hide the prototype function, which will call instantiate.
			instance[i] = instantiate.bind(this, value);
		}
	}
	
	// Add instantiate method.
	instance.instantiate = instantiate.bind(this, function() {});
	
	// Return the isntance.
	return instance;
}

/**
 * @ignore
 */
Class.prototype.bind = function(func)
{
	var context = this;
	if(arguments.length < 2)
	{
		// Fast path if only the 'this' pointer is being bound.
		return function()
		{
			return func.apply(context, arguments);
		}
	}
	else
	{
		// Slower path if additional parameters are being bound.
		var args = Array.prototype.slice.call(arguments, 1);
		return function()
		{
			var finalArgs = args.concat(Array.prototype.slice.call(arguments, 0));
			return func.apply(context, finalArgs);
		}
	}
}

/**
 * @ignore
 */
Class.prototype.toString = function()
{
	return this.constructor.name;
}

// Debug implementation that will replace every method in destroyed objects with a grenade.
/*Class.prototype.destroy = function()
{
	function suicide()
	{
		throw new Error('Function called on destroyed object');
	}
	
	for(var i in this)
	{
		var value = this[i];
		if(typeof(value) == 'function')
		{
			this[i] = suicide;
		}
	}
}*/
