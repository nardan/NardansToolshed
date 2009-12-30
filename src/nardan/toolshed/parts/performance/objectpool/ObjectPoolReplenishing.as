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
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * An ObjectPool that replenishes over time.
	 * 
	 * <p><b>ObjectPoolReplenishing ©2009 Alastair Brown. Licensed under the MIT license</b></p>
	 * 
	 * @author real_nardan@hotmail.com
	 * @version 1.0
	 */
	public class ObjectPoolReplenishing extends ObjectPool
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		private static var _instanceList:Vector.<ObjectPoolReplenishing> =  new Vector.<ObjectPoolReplenishing>();
		private static var _replenishTimer:Timer;
		/***************************************** *
		 * Static Methods
		 * **************************************** */
		/**
		 * Adds and instance to the _instanceList
		 * @param	pool
		 */
		private static function addToInstanceList(pool:ObjectPoolReplenishing):void
		{
			if (!_replenishTimer) {
				_replenishTimer = new Timer(100);
				_replenishTimer.addEventListener(TimerEvent.TIMER, onReplenishTick);
			}
			
			if (!_replenishTimer.running) {
				_replenishTimer.start();
			}
			_instanceList.push(pool);
		}
		
		/**
		 * Removes an instance from the _instanceList
		 * @param	pool
		 */
		private static function removeFromInstanceList(pool:ObjectPoolReplenishing):void
		{
			var index:int = _instanceList.indexOf(pool);
			if (index > -1) {
				_instanceList.splice(index, 1);
				if (_instanceList.length == 0) {
					_replenishTimer.reset();
				}
			}
		}
		
		/**
		 * Gets called every time the replenish timer ticks
		 * @param	e
		 */
		private static function onReplenishTick(e:TimerEvent):void 
		{
			var time:Number =  getTimer();
			for each(var pool:ObjectPoolReplenishing  in _instanceList) {
				pool.replenish(time);
			}
		}
		/* **************************************** *
		 * Properties
		* **************************************** */
		/** Minimum time (milliseconds) between objects replenishing (spawn) */
		protected var spawnTimespan:Number;
		/** Time of next spawning of new object */
		protected var nextSpawnTime:Number;
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		/**
		 * Creates a Pool that replenishes it's self over time
		 * 
		 * @see nardan.toolshed.parts.performance.objectpool.ObjectPool
		 * @param	objectClass: Class to pool
		 * @param	poolSize: size of pool
		 * @param	timespan: minimum time (millieseconds) between spawning. 
		 */
		public function ObjectPoolReplenishing(objectClass:Class, poolSize:uint, timespan:uint) 
		{
			super(objectClass, poolSize);
			this.spawnTimespan = timespan;
			this.nextSpawnTime = getTimer() + this.spawnTimespan;
			addToInstanceList(this);
		}
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		/**
		 * Emptys pool &amp; stops replenishing
		 */
		override public function destroy():void 
		{
			super.destroy();
			removeFromInstanceList(this);
		}
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		/**
		 * Replenish pool by one if needed
		 * @param	time
		 */
		protected function replenish(time:Number):void {
			if (pool.length < poolSize && nextSpawnTime <= time) {
				addNewObjects(1);
				this.nextSpawnTime = time + this.spawnTimespan;
			}
		}
		
	}

	
}