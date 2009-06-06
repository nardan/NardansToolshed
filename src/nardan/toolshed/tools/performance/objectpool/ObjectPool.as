package nardan.toolshed.tools.performance.objectpool 
{
	import flash.utils.Dictionary;
	
	/**
	 * An ObjectPool maintains a list of objects of a specidied Class to be called upon when needed.
	 * 
	 * @author real_nardan@hotmail.com
	 */
	public class ObjectPool {
		/******************************************
		 * Static Constants & Variables
		 ******************************************/
		/******************************************
		 * Static Methods
		 ******************************************/
		/******************************************
		 * Properties
		 ******************************************/
		protected var _poolSize:uint;
		protected var pool:Array;
		protected var classString:String;
		protected var _objectClass:Class;
		
		/******************************************
		 * Constructor
		 ******************************************/
		public function ObjectPool(objectClass:Class, poolSize:uint)
		{
			//trace('ObjectPool::ObjectPool _objectClass = ' + _objectClass + ' poolSize = ' + poolSize);
			this._objectClass = objectClass;
			this._poolSize = poolSize;  
			classString = _objectClass.toString();
			pool = new Array();
			this.populate();
		}
		/******************************************
		 * Getters & Setters
		 ******************************************/
		public function get objectClass():Class { return _objectClass; }
		
		public function get poolSize():uint { return _poolSize; }
		
		/******************************************
		 * Public Methods
		 ******************************************/
		
		 /**
		  * Gets an Object from the pool
		  * @return
		  */
		public function get():*
		{
			var object:* = pool.shift();
				
			if (pool.length == 0)
			{
				populate();
			}
			
			//trace('ObjectPool::get this = '+this+' object = '+object);
			if (object is IPoolable) {
				(object as IPoolable).getPrepare();
			}
			
			return object;
		}
		
		/**
		 * Returns an object to the pool
		 * @param	object
		 */
		public function set(object:*):void
		{
			
			if (object is IPoolable) {
				(object as IPoolable).setPrepare();
			}
			
			if (pool.length < _poolSize) {
				pool.push(object);
			}
			
			//trace('ObjectPool::set this = '+this+' object = '+object);
		}
		
		/**
		 * Populates the pool up to it's max size.
		 */
		public function populate():void
		{
			var len:int = pool.length;
			while (len < _poolSize)
			{
				pool.push(new _objectClass());
				++len;
			}
		}
		
		/**
		 * 
		 * @return
		 */
		public function toString():String
		{
			return '[object ObjectPool class=' + classString + ' size=' + pool.length + ']';
		}
		/******************************************
		 * Event Handlers
		 ******************************************/
		/******************************************
		 * Protected * Private Methods
		 ******************************************/
	}
}
