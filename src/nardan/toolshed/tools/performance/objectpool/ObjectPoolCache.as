package nardan.toolshed.tools.performance.objectpool 
{
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author real_nardan@hotmail.com
	 */
	public class ObjectPoolCache
	{
		/******************************************
		 * Static Constants & Variables
		 ******************************************/
		private static var _instance : ObjectPoolCache;
		private static const POOL_SIZE:int = 5;
		/******************************************
		 * Static Methods
		 ******************************************/
		public static function getInstance():ObjectPoolCache
		{
			if (_instance == null) {
				_instance = new ObjectPoolCache(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/******************************************
		 * Properties
		 ******************************************/
		protected var _pools:Dictionary;
		//public var _pools:Dictionary;
		/******************************************
		 * Constructor
		 ******************************************/
		public function ObjectPoolCache(enforcer:SingletonEnforcer) 
		{
			_pools = new Dictionary();
		}
		/******************************************
		 * Getters & Setters
		 ******************************************/
		public function get pools():Dictionary { return _pools; }
		
		/******************************************
		 * Public Methods
		 ******************************************/
		
		/**
		 * Gets an object from the class pool
		 * @param	objectClass
		 * @return
		 */
		//public function getObject(objectClass:Class):*
		public function get(objectClass:Class):*
		{
			var pool:ObjectPool =  this.getPool(objectClass);
			//var obj:* = pool.getObject();
			var obj:* = pool.get();
			
			return obj
		}
		
		/**
		 * Returns an object to the pool if needed
		 * @param	object
		 */
		//public function setObject(object:*):void
		public function set(object:*):void
		{
			var objectClass:Class = object.constructor as Class;
			var pool:ObjectPool =  this.getPool(objectClass);
			//pool.setObject(object);
			pool.set(object);
		}
		
		/**
		 * Initilaises an object pool
		 * @param	objectClass
		 */
		public function initPool(objectClass:Class, minSize:uint = 0 ):void
		{
			if (_pools[objectClass] == null)
			{
				minSize = (minSize > 0) ? minSize : POOL_SIZE;
				_pools[objectClass] = new ObjectPool(objectClass, minSize);
			}
		}
		
		/**
		 * Standard toString()
		 * @return
		 */
		public function toString():String
		{
			//return ObjectDumper.toString(this);
			var str:String = "";
			for each (var pool:ObjectPool in _pools) {
				str += pool+", ";
			}
			
			if (str.length > 0) str = str.substr(0, str.length-2);
			str = "[object ObjectPoolCache {"+str+"}]";
			return  str
		}
		
		/**
		 * Gets a pool for a specified Class
		 * @param	objectClass
		 * @return
		 */
		public function getPool(objectClass:Class):ObjectPool
		{
			if (_pools[objectClass] == null)
			{
				initPool(objectClass);
			}
			
			return _pools[objectClass] as ObjectPool;
		}
		
		/******************************************
		 * Event Handlers
		 ******************************************/
		/******************************************
		 * Protected * Private Methods
		 ******************************************/
		
		/**
		 * Populates the pool up to POOL_SIZE
		 * @param	objectClass
		 */
		protected function populatePool(objectClass:Class):void
		{
			var pool:ObjectPool = _pools[objectClass];
			pool.populate();
		}
	}
	
}
class SingletonEnforcer { };