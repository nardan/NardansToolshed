package nardan.toolshed.tools.performance.objectpool 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
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
		protected var poolSize:uint;
		protected var pool:Array;
		protected var classString:String;
		protected var objectClass:Class;
		
		/******************************************
		 * Constructor
		 ******************************************/
		public function ObjectPool(objectClass:Class, minSize:uint)
		{
			//trace('ObjectPool::ObjectPool objectClass = ' + objectClass + ' minSize = ' + minSize);
			this.objectClass = objectClass;
			this.poolSize = minSize;  
			classString = objectClass.toString();
			pool = new Array();
			this.populate();
		}
		/******************************************
		 * Getters & Setters
		 ******************************************/
		/******************************************
		 * Public Methods
		 ******************************************/
		
		 /**
		  * Gets an Object from the pool
		  * @return
		  */
		//public function getObject():*
		public function get():*
		{
			var object:* = pool.shift();
				
			if (pool.length == 0)
			{
				populate();
			}
			
			//trace('ObjectPool::getObject this = '+this+' object = '+object);
			if (object is IPoolable) {
				(object as IPoolable).getPrepare();
			}
			
			return object;
		}
		
		/**
		 * Returns an object to the pool
		 * @param	object
		 */
		//public function setObject(object:*):void
		public function set(object:*):void
		{
			
			if (object is IPoolable) {
				(object as IPoolable).setPrepare();
			}
			
			if (pool.length < poolSize) {
				pool.push(object);
			}
			
			//trace('ObjectPool::setObject this = '+this+' object = '+object);
		}
		
		/**
		 * Populates the pool up to it's max size.
		 */
		public function populate():void
		{
			var len:int = pool.length;
			while (len < poolSize)
			{
				pool.push(new objectClass());
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
