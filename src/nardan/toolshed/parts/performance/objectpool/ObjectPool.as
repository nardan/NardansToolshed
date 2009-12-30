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
	 * An ObjectPool maintains a list of objects of a specified Class to be called upon when needed.
	 * 
	 * <p><b>ObjectPool ©2009 Alastair Brown. Licensed under the MIT license</b></p>
	 * @author real_nardan@hotmail.com
	 * @version 1.0
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
		/** @private is protected for sub-classing reasons*/
		protected var _poolSize:uint;
		/** The pool of objects */
		protected var pool:Array;
		/** @private is protected for sub-classing reasons*/
		protected var classString:String;
		/** @private is protected for sub-classing reasons*/
		protected var _objectClass:Class;
		
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		/**
		 * 
		 * @param	objectClass: Class to pool
		 * @param	poolSize: size of pool
		 */
		public function ObjectPool(objectClass:Class, poolSize:uint)
		{
			this._objectClass = objectClass;
			this._poolSize = poolSize;  
			classString = _objectClass.toString();
			pool = new Array();
			addNewObjects(poolSize);
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/** Class of Object Pooled */
		public function get objectClass():Class { return _objectClass; }
		/** Maximum size of pool */
		public function get poolSize():uint { return _poolSize; }
		/** Current size of pool */
		public function get length():uint { return pool.length; }
		
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
			
			if (object is IPoolable) {
				(object as IPoolable).prepareGet();
			}
			
			return object;
		}
		
		/**
		 * Returns an Object to the pool
		 * @param	object
		 */
		public function set(object:*):void
		{
			
			if (object is IPoolable) {
				(object as IPoolable).prepareSet();
			}
			
			if (pool.length < _poolSize) {
				pool.push(object);
			}
		}
		
		/**
		 * Populates the pool up to it's max size.
		 */
		public function populate():void
		{
			var num:uint = _poolSize - pool.length;
			if (num > 0) {
				addNewObjects(num);
			}
		}
		
		/**
		 * Empties the pool
		 */
		public function destroy():void
		{
			pool = new Array();
		}
		
		/** @private standard toString()*/
		public function toString():String
		{
			return '[object ObjectPool class=' + classString + ' length=' + this.length + ']';
		}
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		/**
		 * Adds a number of Objects to the pool
		 * @param	num: number of object to add.
		 */
		protected function addNewObjects(num:uint = 1):void
		{
			if (num < 1) return;
			for (var i:uint = 0 ;  i < num ; ++i)
			{
				pool.push(new _objectClass());
			}
		}
	}
}
