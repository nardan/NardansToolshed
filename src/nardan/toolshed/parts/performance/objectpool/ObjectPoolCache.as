/**
 * Nardan's Tool-Box
 * Copyright (c) 2009 Alastair Brown real_nardan@hotmail.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
 
package nardan.toolshed.parts.performance.objectpool 
{
	import flash.utils.Dictionary;
	
	/**
	 * A singleton to collate, hold and access ObjectPools.
	 * 
	 * @author real_nardan@hotmail.com
	 * @see nardan.toolshed.parts.performance.objectpool.ObjectPool
	 */
	public class ObjectPoolCache
	{
		/* **************************************** *
		 * Static Constants + Variables
		 * **************************************** */
		
		private static var _instance : ObjectPoolCache;
		protected static const DEFAULT_POOL_SIZE:int = 5;
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		
		public static function getInstance():ObjectPoolCache
		{
			if (_instance == null) {
				_instance = new ObjectPoolCache(new SingletonEnforcer());
			}
			return _instance;
		}
		
		/* **************************************** *
		 * Properties
		 * **************************************** */
		protected var _pools:Dictionary;
		
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		public function ObjectPoolCache(enforcer:SingletonEnforcer) 
		{
			_pools = new Dictionary();
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		public function get pools():Dictionary { return _pools; }
		
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		
		/**
		 * Gets an object from the class pool
		 * @param	objectClass
		 */
		public function get(objectClass:Class):*
		{
			var pool:ObjectPool =  this.getPool(objectClass);
			var obj:* = pool.get();
			
			return obj
		}
		
		/**
		 * Returns an object to the pool if needed
		 * @param	object
		 */
		public function set(object:*):void
		{
			var objectClass:Class = object.constructor as Class;
			var pool:ObjectPool =  this.getPool(objectClass);
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
				minSize = (minSize > 0) ? minSize : DEFAULT_POOL_SIZE;
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
		
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
		/**
		 * Populates the pool up to it's max size
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