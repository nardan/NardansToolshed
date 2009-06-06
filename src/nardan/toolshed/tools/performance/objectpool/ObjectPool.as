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
 
package nardan.toolshed.tools.performance.objectpool 
{
	import flash.utils.Dictionary;
	
	/**
	 * An ObjectPool maintains a list of objects of a specidied Class to be called upon when needed.
	 * 
	 * @author real_nardan@hotmail.com
	 */
	public class ObjectPool {
		/* **************************************** *
		 * Static Constants + Variables
		 * **************************************** */
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		/* **************************************** *
		 * Properties
		 * **************************************** */
		protected var _poolSize:uint;
		protected var pool:Array;
		protected var classString:String;
		protected var _objectClass:Class;
		
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		public function ObjectPool(objectClass:Class, poolSize:uint)
		{
			//trace('ObjectPool::ObjectPool _objectClass = ' + _objectClass + ' poolSize = ' + poolSize);
			this._objectClass = objectClass;
			this._poolSize = poolSize;  
			classString = _objectClass.toString();
			pool = new Array();
			this.populate();
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		public function get objectClass():Class { return _objectClass; }
		
		public function get poolSize():uint { return _poolSize; }
		
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		
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
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
	}
}
