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
 

package nardan.toolshed.parts.performance.thread 
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * Dispatched when  <code>iterate()</code> is called. 
	 * 
	 * @see ThreadEvent#ITERATE
	 * @eventType nardan.toolshed.parts.performance.thread.ThreadEvent.ITERATE
	 */
	[Event("ThreadEvent.ITERATE", type = "nardan.toolshed.parts.performance.thread.ThreadEvent")]
	/**
	 * Dispatched when  <code>terminate()</code> is called. 
	 * 
	 * @see ThreadEvent#TERMINATE
	 * @eventType nardan.toolshed.parts.performance.thread.ThreadEvent.TERMINATE
	 */
	[Event("ThreadEvent.TERMINATE", type="nardan.toolshed.parts.performance.thread.ThreadEvent")]
	
	/**
	 * Thread is a class that approximates threading in AS3. This Class is used to create Threads and control their execution.
	 * 
	 * <p><b>Thread ©2009 Alastair Brown. Licensed under the MIT license</b></p>
	 * 
	 * @author real_nardan@hotmail.com
	 * @version 1.0
	 */
	public class Thread extends EventDispatcher implements IThread
	{
		/* **************************************** *
		* Static Constants + Variables
		* **************************************** */
		private static var runList:Vector.<IThread> =  new Vector.<IThread>();
		private static var runTimer:Timer;
		/** Default number of runs per second */
		public static const DEFAULT_RPS:Number = 30;
		private static var _rps:Number = DEFAULT_RPS;
		/* **************************************** *
		 * Static Methods
		 * **************************************** */
		/**
		 * The number of runs per second
		 */
		public static function get rps():Number {
			return rps;
		}
		
		public static function set rps(value:Number):void
		{
			if (value <= 0) throw new Error("Thread: rps must be > 0");
			_rps = value;
			if (runTimer) runTimer.delay = 1000 / _rps;
		}
		
		/**
		 * Adds a thread to the list of running threads.
		 * @param	thread: IThread( thread to add to list)
		 * @param	posn: int(position to add Thread into list)
		 */
		public static function addToRunList(thread:IThread, posn:int = -1):void
		{
			trace('Thread::addToRunList thread = ' + thread);
			if (runList.indexOf(thread) == -1 ) {
				if (posn < 0 || posn >= runList.length) {
					runList.push(thread);
				}else {
					runList.splice(posn, 0, thread);
				}
				if (runTimer == null) createTimer();
			}
		}
		
		/**
		 * Removes an thread from th list of running threads 
		 * @param	thread
		 */
		public static function removeFromRunList(thread:IThread):void
		{
			trace('Thread::removeFromRunList thread = ' + thread);
			var i:int = runList.indexOf(thread);
			if (i > -1) {
				runList.splice(i, 1);
				if (runList.length == 0 && runTimer != null) destroyTimer();
			}
		}
		
		/**
		 * Creates and start the runTimer
		 * @private
		 */
		private static function createTimer():void
		{
			
			runTimer =  new Timer(1000 / _rps);
			runTimer.addEventListener(TimerEvent.TIMER, onRunTimerTick);
			runTimer.start();
			trace('Thread::createTimer runTimer.delay = ' + runTimer.delay);
		}
		
		/**
		 * destroys the runTimer
		 * @private
		 */
		private static function destroyTimer():void
		{
			trace('Thread::destroyTimer');
			runTimer.removeEventListener(TimerEvent.TIMER, onRunTimerTick);
			runTimer =  null;
		}
		
		/**
		 * Get called every time the runTimer ticks.
		 * Executes each threads iterate() upto the threads maxTime or maxIterations. 
		 * Will terminate early if total runnning time greater than the delay of the runTimer.
		 * @param	e
		 */
		private static function onRunTimerTick(e:TimerEvent):void
		{
			//trace('Thread::onRunTimerTick');
			for each (var thread:IThread in runList)
			{
				var tickEnd:int =  Math.floor(getTimer() + runTimer.delay);
				if(thread.active){
					var startTime:int =  getTimer();
					var endTime:int = startTime + thread.maxTime;
					if (tickEnd < endTime) endTime = tickEnd;
					var i:uint = 0;
					var maxI:uint =  thread.maxIterations
					while (thread.iterate() && thread.active &&  maxI > i++ && getTimer() < endTime)
					{
						//trace('Thread::onRunTimerTick i = ' + i);
					}
				}
			}
		}
		/* **************************************** *
		 * Properties
		 * **************************************** */
		/** @private */
		protected var _maxTime:uint;
		/** @private */
		protected var _maxIterations:uint;
		/** @private */
		protected var _active:Boolean = true;
		/* **************************************** *
		 * Constructor
		 * **************************************** */
		/**
		 * Constructor of Thread.
		 * @param	maxIterations: Maximum number of iterations each run
		 * @param	maxTime: Maximum time used each run
		 */
		public function Thread(maxIterations:uint, maxTime:uint) 
		{
			this._maxIterations =  maxIterations;
			this._maxTime =  maxTime;
			addToRunList(this);
		}
		
		/* **************************************** *
		 * Getters + Setters
		 * **************************************** */
		/**
		 * Maximum time used each run.
		 * 
		 */
		public function get maxTime():uint { return _maxTime; }
		/**
		 * Maximum number of iterations each run.
		 */
		public function get maxIterations():uint { return _maxIterations; }
		
		/** The active state of the Thread. If True iterate() will get run */
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void 
		{
			_active = value;
		}
		/* **************************************** *
		 * Public Methods
		 * **************************************** */
		/**
		 * Single iteration of thread
		 * @return Boolean(should the iteration run again if there is time)
		 */
		public function iterate():Boolean
		{
			this.dispatchEvent(new ThreadEvent(ThreadEvent.ITERATE));
			return true;
		}
		
		/**
		 * Terminate the thread
		 */
		public function terminate():void
		{
			this.dispatchEvent(new ThreadEvent(ThreadEvent.TERMINATE));
			this.active =  false;
			removeFromRunList(this);
		}
		/* **************************************** *
		 * Event Handlers
		 * **************************************** */
		/* **************************************** *
		 * Protected + Private Methods
		 * **************************************** */
		
	}

	
}